USE praktikumpbd;


CREATE TABLE satuan (
    idsatuan INT AUTO_INCREMENT PRIMARY KEY,
    nama_satuan VARCHAR(45) NOT NULL,
    status TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE `role` (
    idrole INT AUTO_INCREMENT PRIMARY KEY,
    nama_role VARCHAR(100) NOT NULL
);

CREATE TABLE vendor (
    idvendor INT AUTO_INCREMENT PRIMARY KEY,
    nama_vendor VARCHAR(100) NOT NULL,
    badan_hukum CHAR(1) NOT NULL,
    status CHAR(1) NOT NULL DEFAULT '1'
);


CREATE TABLE `user` (
    iduser INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(45) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    idrole INT NOT NULL,
    FOREIGN KEY (idrole) REFERENCES `role`(idrole) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE barang (
    idbarang INT AUTO_INCREMENT PRIMARY KEY,
    jenis CHAR(1) NOT NULL,
    nama VARCHAR(45) NOT NULL,
    idsatuan INT NOT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    harga INT NOT NULL DEFAULT 0,
    FOREIGN KEY (idsatuan) REFERENCES satuan(idsatuan) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE margin_penjualan (
    idmargin_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    persen DOUBLE NOT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    iduser INT NOT NULL,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (iduser) REFERENCES user(iduser) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE pengadaan (
    idpengadaan BIGINT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_iduser INT NOT NULL,
    status CHAR(1) NOT NULL DEFAULT 'A',
    vendor_idvendor INT NOT NULL,
    subtotal_nilai INT NOT NULL DEFAULT 0,
    ppn INT NOT NULL DEFAULT 0,
    total_nilai INT NOT NULL DEFAULT 0,
    FOREIGN KEY (user_iduser) REFERENCES user(iduser) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (vendor_idvendor) REFERENCES vendor(idvendor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE penerimaan (
    idpenerimaan BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status CHAR(1) NOT NULL DEFAULT '1',
    idpengadaan BIGINT NOT NULL,
    iduser INT NOT NULL,
    FOREIGN KEY (idpengadaan) REFERENCES pengadaan(idpengadaan) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (iduser) REFERENCES user(iduser) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE penjualan (
    idpenjualan INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal_nilai INT NOT NULL DEFAULT 0,
    ppn INT NOT NULL DEFAULT 0,
    total_nilai INT NOT NULL DEFAULT 0,
    iduser INT NOT NULL,
    idmargin_penjualan INT NOT NULL,
    FOREIGN KEY (iduser) REFERENCES user(iduser) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (idmargin_penjualan) REFERENCES margin_penjualan(idmargin_penjualan) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE retur (
    idretur BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idpenerimaan BIGINT NOT NULL,
    iduser INT NOT NULL,
    FOREIGN KEY (idpenerimaan) REFERENCES penerimaan(idpenerimaan) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (iduser) REFERENCES user(iduser) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- FASE 4: TABEL DETAIL TRANSAKSI & LOG KARTU STOK
CREATE TABLE detail_pengadaan (
    iddetail_pengadaan BIGINT AUTO_INCREMENT PRIMARY KEY,
    harga_satuan INT NOT NULL,
    jumlah INT NOT NULL,
    sub_total INT NOT NULL,
    idbarang INT NOT NULL,
    idpengadaan BIGINT NOT NULL,
    FOREIGN KEY (idbarang) REFERENCES barang(idbarang) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (idpengadaan) REFERENCES pengadaan(idpengadaan) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE detail_penerimaan (
    iddetail_penerimaan BIGINT AUTO_INCREMENT PRIMARY KEY,
    idpenerimaan BIGINT NOT NULL,
    barang_idbarang INT NOT NULL,
    jumlah_terima INT NOT NULL,
    harga_satuan_terima INT NOT NULL,
    sub_total_terima INT NOT NULL,
    FOREIGN KEY (idpenerimaan) REFERENCES penerimaan(idpenerimaan) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (barang_idbarang) REFERENCES barang(idbarang) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE detail_penjualan (
    iddetail_penjualan BIGINT AUTO_INCREMENT PRIMARY KEY,
    harga_satuan INT NOT NULL,
    jumlah INT NOT NULL,
    subtotal INT NOT NULL,
    penjualan_idpenjualan INT NOT NULL,
    idbarang INT NOT NULL,
    FOREIGN KEY (penjualan_idpenjualan) REFERENCES penjualan(idpenjualan) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idbarang) REFERENCES barang(idbarang) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE detail_retur (
    iddetail_retur BIGINT AUTO_INCREMENT PRIMARY KEY,
    jumlah INT NOT NULL,
    alasan VARCHAR(200) NOT NULL,
    idretur BIGINT NOT NULL,
    iddetail_penerimaan BIGINT NOT NULL,
    FOREIGN KEY (idretur) REFERENCES retur(idretur) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (iddetail_penerimaan) REFERENCES detail_penerimaan(iddetail_penerimaan) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE kartu_stok (
    idkartu_stok BIGINT AUTO_INCREMENT PRIMARY KEY,
    jenis_transaksi CHAR(1) NOT NULL,
    masuk INT NOT NULL DEFAULT 0,
    keluar INT NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idtransaksi INT NOT NULL,
    idbarang INT NOT NULL,
    FOREIGN KEY (idbarang) REFERENCES barang(idbarang) ON DELETE RESTRICT ON UPDATE CASCADE
);

SHOW TABLES;
	DESCRIBE kartu_stok; 
	
	
	
	QUERY DML
	
INSERT INTO `role` (idrole, nama_role)
VALUES
(2, 'Petugas Gudang'),
(3, 'Kasir'),
(4, 'Manajer');
SELECT * FROM `role`

SELECT * FROM `user`;

INSERT INTO `user` (iduser, username, password, idrole)
VALUES
(2, 'petugas_gudang',
'GudangPBD#2026', 2),

(3, 'kasir',
'KasirPBD#2026', 3),

(4, 'manajer',
'ManajerPBD#2026', 4);

INSERT INTO satuan (idsatuan, nama_satuan, status)
VALUES
(1, 'Pcs', 1),
(2, 'Box', 1),
(3, 'Kilogram', 1),
(4, 'Liter', 1),
(5, 'Pack', 1);
SELECT * from satuan;

INSERT INTO barang
(idbarang, jenis, nama, idsatuan, status, harga)
VALUES
(1, '1', 'Beras Premium', 3, 1, 18000),
(2, '1', 'Minyak Goreng', 4, 1, 20000),
(3, '1', 'Gula Pasir', 3, 1, 16000),
(4, '1', 'Tepung Terigu', 3, 1, 12000),
(5, '1', 'Kopi Bubuk', 5, 1, 22000),
(6, '1', 'Teh Celup', 2, 1, 18000),
(7, '1', 'Air Mineral', 1, 1, 4000),
(8, '1', 'Susu UHT', 1, 1, 7000),
(9, '1', 'Mi Instan', 1, 1, 3500),
(10, '1', 'Tisu', 5, 1, 15000);
SELECT * FROM barang;

INSERT INTO vendor
(idvendor, nama_vendor, badan_hukum, status)
VALUES
(1, 'PT Sumber Makmur', '1', '1'),
(2, 'PT Distribusi Nusantara', '1', '1'),
(3, 'CV Mitra Sejahtera', '0', '1'),
(4, 'UD Berkah Jaya', '0', '1'),
(5, 'PT Indo Pangan', '1', '1');
SELECT * FROM vendor;



INSERT INTO margin_penjualan (persen, status, iduser) VALUES 
(10.0, 0, 1), 
(20.0, 1, 1), 
(30.0, 0, 1), 
(40.0, 0, 1), 
(50.0, 0, 1);
SELECT * FROM margin_penjualan


QUERY VIEW DATA MASTER

CREATE VIEW v_master_barang AS
SELECT b.idbarang,b.jenis,b.nama AS nama_barang,s.nama_satuan,b.harga,b.status
FROM barang b
JOIN satuan s ON b.idsatuan = s.idsatuan;


CREATE VIEW v_master_user AS
SELECT u.iduser,u.username,r.nama_role
FROM `user` u
JOIN `role` r ON u.idrole = r.idrole;


CREATE VIEW v_margin_aktif AS
SELECT idmargin_penjualan,persen,status,created_at
FROM margin_penjualan
WHERE status = 1;


CREATE VIEW v_master_vendor AS
SELECT idvendor, nama_vendor, badan_hukum, status FROM vendor;


CREATE VIEW v_master_satuan AS
SELECT idsatuan, nama_satuan, status FROM satuan;


CREATE VIEW v_master_role AS
SELECT idrole, nama_role FROM `role`;
