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
