DELIMITER //

CREATE PROCEDURE ListarComprasCliente(
    IN cliente_id INT,
    IN data_inicial DATE,
    IN data_final DATE
)
BEGIN
    SELECT 
        c.nome AS NomeCliente,
        v.id AS IDCompra,
        v.valor_total AS Total,
        p.nome AS NomeProduto,
        iv.quantidade AS Quantidade
    FROM
        cliente c
    JOIN
        venda v ON c.id = v.cliente_id
    JOIN
        item_venda iv ON v.id = iv.venda_id
    JOIN
        produto p ON iv.produto_id = p.id
    WHERE
        c.id = cliente_id
        AND v.data BETWEEN data_inicial AND DATE_ADD(data_final, INTERVAL 1 DAY);
END;
//
DELIMITER ;

/* CALL ListarComprasCliente(1, '2023-01-01', '2023-12-31'); */


DELIMITER //
CREATE FUNCTION DeterminarStatusCliente(cliente_id INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE total_compras DECIMAL(9,2);
    SELECT SUM(v.valor_total) INTO total_compras
    FROM venda v
    WHERE v.cliente_id = cliente_id;

    IF total_compras > 10000 THEN
        RETURN 'PREMIUM';
    ELSE
        RETURN 'REGULAR';
    END IF;
END;
//
DELIMITER ;

/* SELECT DeterminarStatusCliente(1); */

DELIMITER //
CREATE TRIGGER SenhaMD5 BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
    SET NEW.senha = MD5(NEW.senha);
END;
//
DELIMITER ;
