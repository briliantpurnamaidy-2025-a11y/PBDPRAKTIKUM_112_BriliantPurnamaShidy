
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


SELECT * FROM v_master_user;
SELECT * FROM v_master_satuan;
SELECT * FROM v_master_barang;
SELECT * FROM v_master_vendor;
SELECT * FROM v_margin_aktif;
