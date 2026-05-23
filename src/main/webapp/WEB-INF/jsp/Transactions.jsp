<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <title>Maintenance</title>
  <meta charset="utf-8">
 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <script src="/js/jquery.min.js"></script>
  <script src="/js/bootstrap.min.js"></script>
  <style>
    .delete-confirm-modal .modal-dialog {
      position: fixed;
      top: 16px;
      left: 50%;
      transform: translateX(-50%) !important;
      margin: 0;
      width: calc(100% - 20px);
      max-width: 420px;
    }
    .delete-confirm-modal {
      overflow: hidden !important;
    }
    .delete-confirm-modal .modal-content {
      overflow: hidden;
    }
    .delete-confirm-modal .modal-footer .btn {
      min-width: 90px;
    }
    @media (max-width: 767px) {
      .delete-confirm-modal .modal-dialog {
        top: 10px;
        width: calc(100% - 16px);
      }
    }
  </style>
</head>
<body>

<div class="container-fluid">
 
  <form autocomplete="off">
 
  <div class="col-md-12">
  <div class="panel panel-primary">
  	<div class="panel-heading"><a href="home" class="btn btn-info btn-sm">
		<span class="glyphicon glyphicon-home"></span> 
	  </a> Transactions </div>
  		<div class="panel-body">
			<div class="form-group col-md-3">
				<label for="memberId">Transaction Type</label>
				<select class="form-control" id="transactionType" name="transactionType">
				 <option value="">--Select--</option>
				 <option value="Credit">Credit</option>		
				 <option value="Debit">Debit</option>				 		 		    			    
				</select>
			  </div>

			<div class="form-group col-md-3">
				<label for="amount">Transaction Amount</label>
				<input type="number" class="form-control" id="amount"  name="amount">
			</div>

			<div class="form-group col-md-3">
				<label for="purposeOfTransaction">Purpose of Transaction</label>
					<textarea type="text" class="form-control" id="purposeOfTransaction"  name="purposeOfTransaction"></textarea>
			  </div>
		    
		    
			<input type="hidden" class="form-control" id="id"  name="id">

			<div class="form-group col-md-12">
				<button type="button" class="btn btn-success" id="save">Save</button>   
				<button type="button" class="btn btn-primary" id="search">Search</button>
				<button type="button" class="btn btn-info" id="update">Update</button>   	   
		    	    
		  </div>
	</div>
	</div>
  </form>
  
  

    
	<div class="col-md-12" id="investorListDiv">
	<div class="panel panel-primary">
		<div class="panel-heading">Transactions Details <label id="totalTransactionAmount" style="color: yellow;"></label></div>
		<div class="panel-body"> 
			<div class="table-responsive">          
				<table class="table-bordered table-striped table table-hover documentUpload" >
					<thead>
					<tr>
						<th>Sl.No</th>
						<th>Transaction Type</th>
						<th>Transaction Amount</th>
						<th>Purpose of Transaction</th>	
						<th>Transaction Date</th>												
						<th>Actions</th>
					</tr>
					</thead>  
					<tbody>    
				<tbody id="tbdata"> 
				</tbody>					
			</div>
			</div>
			</div>
			</div>
	</div>
<script>
$(document).ready(function(){

	$('#update').hide();

	function showDeleteConfirmModal(message, onConfirm) {
		$("#deleteConfirmMessage").text(message || "Are you sure you want to delete?");
		$("#deleteConfirmOkBtn")
			.off("click.deleteConfirm")
			.on("click.deleteConfirm", function () {
				$("#deleteConfirmModal").modal("hide");
				if (typeof onConfirm === "function") {
					onConfirm();
				}
			});

		$("#deleteConfirmModal")
			.off("hidden.bs.modal.deleteConfirm")
			.on("hidden.bs.modal.deleteConfirm", function () {
				$("#deleteConfirmOkBtn").off("click.deleteConfirm");
			});

		$("#deleteConfirmModal").modal("show");
	}


    $("#save").click(function(){    
        
        var transactionType = $("#transactionType").val();
        var purposeOfTransaction = $("#purposeOfTransaction").val();
        var amount = $("#amount").val();

		
        var payload={
        		'transactionType':transactionType,        		
        		'amount':amount,
				'purposeOfTransaction': purposeOfTransaction       		
         };
		 if(payload.transactionType == '' || payload.transactionType == null || payload.transactionType == undefined ||
		 payload.amount == '' || payload.amount == null || payload.amount == undefined ||
		 payload.purposeOfTransaction == '' || payload.purposeOfTransaction == null || payload.purposeOfTransaction == undefined) {
			alert('Fill all fields in form');
			return false;

		 }

        $.ajax({
			  url: "/transactions/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {	
			}
		})
		.done(function(data){
            alert('Transactions saved Successfully');
			$("#transactionType").val('');
			$("#purposeOfTransaction").val('');
			$("#amount").val('');
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;	
			alert(errorMsg);	
			
		})
		.always(function(data, textStatus, jqXHR){	
			$("#search").click();
		
		});
	
    });

	$("#search").click(function(){    

		var transactionType = $("#transactionType").val();
		var url ="/transactions/fetch";
		if (transactionType !=null && transactionType != '') {
			url ="/transactions/fetch/"+transactionType;
		}
        
        $.ajax({
			  url: url,		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            if(data.length>0){
         	    var trHTML = '';
       		   $('#tbdata').empty();
			   var totalTransactionAmount = 0;
       	        $.each(data,function(index, item){   

				
					        	
       	        	 var insno= index+1; 
					 if(item.transactionType != null && item.transactionType != undefined && item.transactionType == 'Credit') {
						totalTransactionAmount = totalTransactionAmount +  item.amount; 
						var flag= '<span class="label label-success">Credit</span>'; 
					 } else {
						totalTransactionAmount = totalTransactionAmount -  item.amount; 
						var flag= '<span class="label label-danger">Debit</span>'; 
					 }
					    	        	 
     		         trHTML += '<tr><td>'+insno+'</td><td>'+flag+'</td><td>'+item.amount+'</td><td>'
						+item.purposeOfTransaction+'</td><td>'+item.creationDateTime+'</td><td> <button type="button" class="btn btn-success btn-sm" value="'+item.transactionId+'" id="edit"><span class="glyphicon">&#xe065;</span></button></td>'+
								'<td> <button type="button" class="btn btn-danger btn-sm" value="'+item.transactionId+'" id="delete"><span class="glyphicon">&#xe020;</span></button></td></tr>';
     		      }); 
				   $('#totalTransactionAmount').empty();

				   $('#totalTransactionAmount').append('( Total Transactions Amount : '+totalTransactionAmount +' )');
				   
       	          $('#tbdata').append(trHTML);
       	          $("#investorListDiv").show();
       	 }else{
       		    var trHTML = '';
     		    $('#tbdata').empty();
     		  	trHTML += '<td rowspan="6" style="color: Red;">No Search Found</td>';
  		        $('#tbdata').append(trHTML);
     	        $("#investorListDiv").show();                 
           }
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;		
			
		})
		.always(function(data, textStatus, jqXHR){	
						
		});
	
    });

	$('body').on('click', '#delete', function() {  
		
        var id = $(this).val();
		showDeleteConfirmModal("Delete this transaction?", function () {
			$.ajax({
				  url: "/transactions/delete/"+id,		  			  
				  type: "GET",
				  contentType: "application/json",			  
				  beforeSend: function() {		  				
				}
			})
			.done(function(data){
	            alert('Transaction Deleted Successfully');
				
	     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
				var errorResponseObj = jqXHR.responseJSON;
				var errorMsg = errorResponseObj.errorMessage;	
				alert(errorMsg);
				
			})
			.always(function(data, textStatus, jqXHR){	
				$("#search").click();		
			});
		});
	
    });

	$('body').on('click', '#edit', function() {  
		$('#save').hide();
		$('#search').hide();
		$('#update').show();

        var id = $(this).val();   
        $.ajax({
			  url: "/transactions/edit/"+id,		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
			$("#transactionType").val(data.transactionType);
			$("#purposeOfTransaction").val(data.purposeOfTransaction);
			$("#amount").val(data.amount);
			$("#id").val(data.transactionId);
			
			
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;
			$('#update').hide();
			$('#save').show();
			$('#search').show();
		})
		.always(function(data, textStatus, jqXHR){	
			
		});
	
    });

	
    $("#update").click(function(){    
		var transactionType = $("#transactionType").val();
        var purposeOfTransaction = $("#purposeOfTransaction").val();
        var amount = $("#amount").val();
		var transactionId = $("#id").val();

		
        var payload={
        		'transactionType':transactionType,        		
        		'amount':amount,
				'purposeOfTransaction': purposeOfTransaction,
				'transactionId' : transactionId     		
         };
		 if(payload.transactionType == '' || payload.transactionType == null || payload.transactionType == undefined ||
		 payload.amount == '' || payload.amount == null || payload.amount == undefined ||
		 payload.purposeOfTransaction == '' || payload.purposeOfTransaction == null || payload.purposeOfTransaction == undefined) {
			alert('Fill all fields in form');
			return false;

		 }
        $.ajax({
			  url: "/transactions/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            alert('Transaction Updated Successfully');			
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;	
			alert(errorMsg);	
			
		})
		.always(function(data, textStatus, jqXHR){	
			$("#search").click();
			$('#save').show();
			$('#search').show();
			$('#update').hide();
			$("#transactionType").val('');
			$("#purposeOfTransaction").val('');
			$("#amount").val('');
			$("#id").val('');
		
		});
	
    });
});
</script>
<div id="deleteConfirmModal" class="modal delete-confirm-modal" role="dialog" aria-labelledby="deleteConfirmTitle">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="deleteConfirmTitle">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
        <p id="deleteConfirmMessage">Are you sure you want to delete?</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-danger" id="deleteConfirmOkBtn">Delete</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
