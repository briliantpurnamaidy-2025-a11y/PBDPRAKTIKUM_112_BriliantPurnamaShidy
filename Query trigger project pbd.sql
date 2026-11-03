CREATE FUNCTION fn_hitung_harga_jual(
    p_harga DECIMAL(12,2),
    p_markup DECIMAL(5,2)
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
NO SQL
RETURN ROUND(
    p_harga * (1 + p_markup / 100),
    2
);

SHOW TRIGGERS LIKE 'detail_penerimaan';

DELIMITER $$

CREATE TRIGGER trg_kartu_stok_masuk
AFTER INSERT ON detail_penerimaan
FOR EACH ROW
BEGIN
    DECLARE v_kunci INT;
    DECLARE v_stok_akhir INT DEFAULT 0;

    IF NEW.jumlah_terima <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Jumlah penerimaan harus positif';
    END IF;

    SELECT idbarang INTO v_kunci
    FROM barang
    WHERE idbarang = NEW.barang_idbarang
    FOR UPDATE;

    SELECT COALESCE((
        SELECT stock
        FROM kartu_stok
        WHERE idbarang = NEW.barang_idbarang
        ORDER BY idkartu_stok DESC
        LIMIT 1
    ), 0)
    INTO v_stok_akhir;

    INSERT INTO kartu_stok
    (
        jenis_transaksi,
        masuk,
        keluar,
        stock,
        idtransaksi,
        idbarang
    )
    VALUES
    (
        'M',
        NEW.jumlah_terima,
        0,
        v_stok_akhir + NEW.jumlah_terima,
        NEW.idpenerimaan,
        NEW.barang_idbarang
    );
END$$

DELIMITER ;

SHOW TRIGGERS LIKE 'detail_penerimaan';
