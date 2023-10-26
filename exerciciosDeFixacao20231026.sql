-- 01)

delimiter //

create trigger after_insert_cliente after insert on Clientes for each row
begin
	insert into Auditoria(mensagem) values('Novo cliente adicionado!!')
end; //

delimiter ;

-- 02)

delimiter //

create trigger before_delete_cliente before delete on Clientes for each row
begin
	insert into Auditoria(mensagem) values('tentaram excluir um cliente!!');
end; //

delimiter ;

-- 03)

delimiter //

create trigger after_update_cliente after update on Clientes for each row
begin
	insert into Auditoria(mensagem) values(concat('mudaram um nome!! de ', old.nome,' para ', new.nome));
end; //

delimiter ;

-- 04)

delimiter //

create trigger warning before update on Clientes for each row
begin
	if (new.nome is null or new.nome = '') then
		insert into Auditoria(mensagem) values('tentativa de adição de nome vazio ou nulo!!');
        delete new.nome from Clientes; 
	end if; 
end; //

delimiter ;

-- 05)

delimiter //

create trigger DecrementarEstoque after insert on Pedidos for each row
begin
    declare estoque_atual int;
    
	select estoque into estoque_atual from Produtos where id = new.produto_id;
    
    if ((estoque_atual - NEW.quantidade) < 5) then
        insert into Auditoria (mensagem) values ('Estoque baixo para o produto ID ', new.produto_id);
    end if;
    
	update Produtos set estoque = estoque_atual - new.quantidade where id = new.produto_id;
    
end; //

delimiter ;
