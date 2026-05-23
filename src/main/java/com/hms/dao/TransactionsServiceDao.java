package com.hms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.Transactions;

public interface TransactionsServiceDao extends JpaRepository<Transactions,Long>{
	public List<Transactions> findByTransactionType(String transactionType);

}
