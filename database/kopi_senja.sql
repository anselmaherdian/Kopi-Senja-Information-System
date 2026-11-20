CREATE DATABASE kopi_senja;
USE kopi_senja;

-- 1. Tabel Cabang
CREATE TABLE cabang (
    id_cabang INT AUTO_INCREMENT PRIMARY KEY,
    nama_cabang VARCHAR(100) NOT NULL,
    alamat TEXT
) ENGINE=InnoDB;

-- 2. Tabel Pengguna
CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    id_cabang INT NOT NULL,
    nama_pengguna VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Kasir','Barista','Manajer')
    NOT NULL,
    FOREIGN KEY (id_cabang)
    REFERENCES cabang(id_cabang)
) ENGINE=InnoDB;

-- 3. Tabel Pelanggan
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama_pelanggan VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20)
) ENGINE=InnoDB;

-- 4. Tabel Menu
CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nama_menu VARCHAR(100) NOT NULL,
    harga DECIMAL(12,2) NOT NULL,
    status ENUM('Tersedia','Habis')
    DEFAULT 'Tersedia'
) ENGINE=InnoDB;

-- 5. Tabel Pesanan
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT PRIMARY KEY,
    id_cabang INT NOT NULL,
    id_pelanggan INT NOT NULL,
    id_pengguna INT NULL,
    tanggal DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL,
    status ENUM(
        'Menunggu Pembayaran',
        'Diproses',
        'Siap Diambil',
        'Selesai',
        'Dibatalkan'
    ) DEFAULT 'Menunggu Pembayaran',

    FOREIGN KEY (id_cabang)
    REFERENCES cabang(id_cabang),

    FOREIGN KEY (id_pelanggan)
    REFERENCES pelanggan(id_pelanggan),

    FOREIGN KEY (id_pengguna)
    REFERENCES pengguna(id_pengguna)
) ENGINE=InnoDB;

-- 6. Tabel Detail Pesanan
CREATE TABLE detail_pesanan (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_pesanan INT NOT NULL,
    id_menu INT NOT NULL,
    qty INT NOT NULL,
    harga_satuan DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (id_pesanan)
    REFERENCES pesanan(id_pesanan),

    FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu)
) ENGINE=InnoDB;

-- 7. Tabel Pembayaran
CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    id_pesanan INT NOT NULL UNIQUE,
    metode ENUM('Tunai','QRIS') NOT NULL,
    jumlah_bayar DECIMAL(12,2) NOT NULL,
    status ENUM('Berhasil','Gagal','Pending')
    DEFAULT 'Pending',

    FOREIGN KEY (id_pesanan)
    REFERENCES pesanan(id_pesanan)
) ENGINE=InnoDB;

-- 8. Tabel Bahan Baku
CREATE TABLE bahan_baku (
    id_bahan INT AUTO_INCREMENT PRIMARY KEY,
    nama_bahan VARCHAR(100) NOT NULL,
    satuan VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

-- 9. Tabel Resep Menu
CREATE TABLE resep_menu (
    id_resep INT AUTO_INCREMENT PRIMARY KEY,
    id_menu INT NOT NULL,
    id_bahan INT NOT NULL,
    jumlah_bahan DECIMAL(12,3) NOT NULL,

    FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu),

    FOREIGN KEY (id_bahan)
    REFERENCES bahan_baku(id_bahan)
) ENGINE=InnoDB;

-- 10. Tabel Stok Cabang
CREATE TABLE stok_cabang (
    id_stok INT AUTO_INCREMENT PRIMARY KEY,
    id_cabang INT NOT NULL,
    id_bahan INT NOT NULL,
    jumlah_stok DECIMAL(12,3) NOT NULL,
    stok_minimum DECIMAL(12,3) NOT NULL,

    UNIQUE (id_cabang, id_bahan),

    FOREIGN KEY (id_cabang)
    REFERENCES cabang(id_cabang),

    FOREIGN KEY (id_bahan)
    REFERENCES bahan_baku(id_bahan)
) ENGINE=InnoDB;
