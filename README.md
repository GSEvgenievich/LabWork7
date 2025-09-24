using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

class FileStorage
{
    private readonly string mainDir;
    private readonly string mirrorDir;

    public FileStorage(string mainDirectory, string mirrorDirectory)
    {
        if (!Directory.Exists(mainDirectory))
            throw new DirectoryNotFoundException($"Основной каталог не найден: {mainDirectory}");
        if (!Directory.Exists(mirrorDirectory))
            throw new DirectoryNotFoundException($"Каталог-зеркало не найден: {mirrorDirectory}");

        mainDir = mainDirectory;
        mirrorDir = mirrorDirectory;
    }

    // 5.3.1 Загрузка файла с зеркалированием и созданием checksum
    public void UploadFile(string sourceFilePath)
    {
        if (!File.Exists(sourceFilePath))
            throw new FileNotFoundException($"Исходный файл не найден: {sourceFilePath}");

        string fileName = Path.GetFileName(sourceFilePath);

        string mainFilePath = Path.Combine(mainDir, fileName);
        string mirrorFilePath = Path.Combine(mirrorDir, fileName);

        // Копируем файл в оба каталога
        File.Copy(sourceFilePath, mainFilePath, overwrite: true);
        File.Copy(sourceFilePath, mirrorFilePath, overwrite: true);

        // Вычисляем чек-сумму исходного файла
        string checksum = ComputeChecksum(sourceFilePath);

        // Записываем чек-сумму в оба каталога
        File.WriteAllText(mainFilePath + ".checksum", checksum, Encoding.UTF8);
        File.WriteAllText(mirrorFilePath + ".checksum", checksum, Encoding.UTF8);

        Console.WriteLine($"Файл '{fileName}' загружен и зеркалирован с чек-суммами.");
    }

    // 5.3.2 Выгрузка файла с проверкой чек-сумм и восстановлением из зеркала при необходимости
    public void DownloadFile(string fileName, string destinationPath)
    {
        string mainFilePath = Path.Combine(mainDir, fileName);
        string mirrorFilePath = Path.Combine(mirrorDir, fileName);

        if (!File.Exists(mainFilePath))
        {
            Console.WriteLine($"Основной файл '{fileName}' не найден.");
            return;
        }

        if (!File.Exists(mirrorFilePath))
        {
            Console.WriteLine($"Файл-зеркало '{fileName}' не найден.");
            return;
        }

        string mainChecksumFile = mainFilePath + ".checksum";
        string mirrorChecksumFile = mirrorFilePath + ".checksum";

        if (!File.Exists(mainChecksumFile) || !File.Exists(mirrorChecksumFile))
        {
            Console.WriteLine("Отсутствуют файлы с чек-суммами.");
            return;
        }

        string mainChecksumStored = File.ReadAllText(mainChecksumFile, Encoding.UTF8);
        string mirrorChecksumStored = File.ReadAllText(mirrorChecksumFile, Encoding.UTF8);

        string mainChecksumActual = ComputeChecksum(mainFilePath);
        string mirrorChecksumActual = ComputeChecksum(mirrorFilePath);

        bool mainOk = mainChecksumStored == mainChecksumActual;
        bool mirrorOk = mirrorChecksumStored == mirrorChecksumActual;

        if (mainOk)
        {
            // Основной файл корректен — копируем его
            File.Copy(mainFilePath, destinationPath, overwrite: true);
            Console.WriteLine($"Файл '{fileName}' выгружен из основного каталога.");
        }
        else if (!mainOk && mirrorOk)
        {
            // Восстанавливаем из зеркала
            File.Copy(mirrorFilePath, destinationPath, overwrite: true);
            Console.WriteLine($"Основной файл повреждён. Файл '{fileName}' восстановлен из зеркала.");
        }
        else
        {
            Console.WriteLine($"Ошибка: оба файла '{fileName}' повреждены или отсутствуют корректные чек-суммы.");
        }
    }

    private string ComputeChecksum(string filePath)
    {
        using (var sha256 = SHA256.Create())
        using (var stream = File.OpenRead(filePath))
        {
            byte[] hashBytes = sha256.ComputeHash(stream);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
        }
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Введите путь к основному каталогу:");
        string mainDir = Console.ReadLine();

        Console.WriteLine("Введите путь к каталогу-зеркалу:");
        string mirrorDir = Console.ReadLine();

        try
        {
            var storage = new FileStorage(mainDir, mirrorDir);

            while (true)
            {
                Console.WriteLine("\nВыберите действие:\n1 - Загрузить файл\n2 - Выгрузить файл\n0 - Выход");
                string choice = Console.ReadLine();

                if (choice == "0") break;

                switch (choice)
                {
                    case "1":
                        Console.WriteLine("Введите путь к файлу для загрузки:");
                        string uploadPath = Console.ReadLine();
                        storage.UploadFile(uploadPath);
                        break;

                    case "2":
                        Console.WriteLine("Введите имя файла для выгрузки:");
                        string fileName = Console.ReadLine();

                        Console.WriteLine("Введите путь для сохранения выгруженного файла:");
                        string destPath = Console.ReadLine();

                        storage.DownloadFile(fileName, destPath);
                        break;

                    default:
                        Console.WriteLine("Некорректный выбор.");
                        break;
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка: {ex.Message}");
        }
    }
}
