package com.hms.serviceImpl;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hms.dao.TransactionsServiceDao;
import com.hms.entity.Transactions;
import com.hms.service.TransactionsService;

@Service
public class TransactionsServiceImpl implements TransactionsService{
	
	@Autowired
	TransactionsServiceDao dao;

	@Override
	public Transactions save(Transactions transactions) {		
		transactions.setCreationDateTime(Date.valueOf(LocalDate.now()));
		return dao.save(transactions);
		
	}

	@Override
	public List<Transactions> fetch() {
		return dao.findAll();
	}

	@Override
	public String delete(Long id) {
		dao.deleteById(id);		
		return "Transaction Deleted Successfully";
	}

	@Override
	public Optional<Transactions> edit(Long id) {
		return dao.findById(id);
	}

	@Override
	public List<Transactions> findByTransactionType(String transactionType) {
		return dao.findByTransactionType(transactionType);
		
	}



	

}
