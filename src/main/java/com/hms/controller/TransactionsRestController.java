package com.hms.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.entity.Transactions;
import com.hms.service.TransactionsService;

@RestController
@RequestMapping("/transactions")
@CrossOrigin

public class TransactionsRestController {
	
	@Autowired
	TransactionsService transactionsService;
	

	@PostMapping("/save")
	public Transactions save(@RequestBody Transactions transactions) {
		return transactionsService.save(transactions);		
	}
	
	@GetMapping("/fetch")
	public List<Transactions> fetch() {
		return transactionsService.fetch();
		
	}
	@GetMapping("/fetch/{transactionType}")
	public List<Transactions> fetch(@PathVariable String transactionType) {
		return transactionsService.findByTransactionType(transactionType);
		
	}
	
	@GetMapping("/delete/{id}")
	public String delete(@PathVariable Long id) {
		return transactionsService.delete(id);
		
	}
	@GetMapping("/edit/{id}")
	public Optional<Transactions> edit(@PathVariable Long id) {
		return transactionsService.edit(id);
		
	}
	
	
	
	
}
