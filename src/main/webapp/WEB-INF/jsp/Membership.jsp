<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <title>Membership Details</title>
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
	  </a> Membership </div>
  		<div class="panel-body">
			<div class="form-group col-md-3">
				<label for="firstName">First Name</label>
				<input type="text" class="form-control" id="firstName"  name="firstName">
			</div>
			<div class="form-group col-md-3">
				<label for="lastName">Last Name</label>
				<input type="text" class="form-control" id="lastName"  name="lastName">
			</div>
			<div class="form-group col-md-3">
				<label for="mobileNumber">Mobile Number	</label>
				<input type="text" class="form-control" id="mobileNumber"  name="mobileNumber" maxlength="10">
			</div>
		    
		    <div class="form-group col-md-3">
		      <label for="memberType">Member type</label>
		      <select class="form-control" id="memberType" name="memberType">
		       <option value="">--Select--</option>
		       <option value="Owner">Owner</option>
			   <option value="Open Plot">Open Plot</option>			    			    
			  </select>
		    </div>

			<div class="form-group col-md-3">
				<label for="memberType">Membership</label>
				<select class="form-control" id="memberShipFlag" name="memberShipFlag">
				 <option value="">--Select--</option>
				 <option value="true">Yes</option>
				 <option value="false">No</option>			    			    
				</select>
			  </div>

			<div class="form-group col-md-3">
				<label for="memberShipAmount">Membership Amount</label>
				<input type="number" class="form-control" id="memberShipAmount"  name="memberShipAmount">
			</div>
		    
		    <div class="form-group col-md-6">
		      <label for="fullAddress">Full Address</label>
		      	<textarea type="text" class="form-control" id="fullAddress"  name="fullAddress"></textarea>
		    </div>

			<input type="hidden" class="form-control" id="memberId"  name="memberId">

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
		<div class="panel-heading">Membership Details <label id="totalMembershipAmount" style="color: yellow;"></label></div>
		<div class="panel-body"> 
			<div class="table-responsive">          
				<table class="table-bordered table-striped table table-hover documentUpload" >
					<thead>
					<tr>
						<th>Sl.No</th>
						<th>First Name</th>
						<th>Last Name</th>
						<th>Mobile Number</th>
						<th>Member type</th>
						<th>Membership</th>
						<th>Membership Amount</th>
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

	$("#memberShipFlag").change(function(){ 
		var memberShipFlag = $("#memberShipFlag").val();
		if(memberShipFlag == "true" && memberShipFlag != null && memberShipFlag != undefined) {
			var memberShipAmount = $("#memberShipAmount").val(3000.00);
		} else {
			var memberShipAmount = $("#memberShipAmount").val(0.00);
		}
	 });

    $("#save").click(function(){    
        var firstName = $("#firstName").val();
        var lastName = $("#lastName").val();
        var mobileNumber = $("#mobileNumber").val();
        var fullAddress = $("#fullAddress").val();
		var memberShipFlag = $("#memberShipFlag").val();
		var memberShipAmount = $("#memberShipAmount").val();
		var memberType = $("#memberType").val();


        var payload={
        		'firstName':firstName,
        		'lastName':lastName,
        		'mobileNumber':mobileNumber,
        		'memberShipFlag':memberShipFlag,
				'memberType':memberType,
				'memberShipAmount':memberShipAmount,
				'fullAddress':fullAddress
        		
         };

		 if(payload.firstName == '' || payload.firstName == null || payload.firstName == undefined ||
		 payload.lastName == '' || payload.lastName == null || payload.lastName == undefined ||
		 payload.mobileNumber == '' || payload.mobileNumber == null || payload.mobileNumber == undefined ||
		 payload.memberShipFlag == '' || payload.memberShipFlag == null || payload.memberShipFlag == undefined || 
		 payload.memberType == '' || payload.memberType == null || payload.memberType == undefined ||
		 payload.memberShipAmount == '' || payload.memberShipAmount == null || payload.memberShipAmount == undefined ||
		 payload.fullAddress == '' || payload.fullAddress == null || payload.fullAddress == undefined) {
			alert('Fill all fields in form');
			return false;

		 }
        $.ajax({
			  url: "/member/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            alert('Member saved Successfully');
			$("#firstName").val('');
			$("#lastName").val('');
			$("#mobileNumber").val('');
			$("#fullAddress").val('');
			$("#memberShipFlag").val('');
			$("#memberShipAmount").val('');
			$("#memberType").val('');
			$("#memberId").val('');
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
		var memberShipFlag = $("#memberShipFlag").val(); 
		var url ='';
		if(memberShipFlag == '' || memberShipFlag == null || memberShipFlag == undefined) {
			url = "/member/fetch";
		}  else {
			url = "/member/fetch/"+memberShipFlag;
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
			   var totalMembershipAmount = 0;
       	        $.each(data,function(index, item){   
					if(item.memberShipFlag == true) {
						var flag= '<span class="label label-success">Yes</span>';  
					}
					else {
						var flag= '<span class="label label-danger">No</span>';  
					}
						        	
       	        	 var insno= index+1; 
						totalMembershipAmount = totalMembershipAmount +  item.memberShipAmount;     	        	 
     		         trHTML += '<tr><td>'+insno+'</td><td>'+item.firstName+'</td><td>'+item.lastName+'</td><td>'
						+item.mobileNumber+'</td><td>'+item.memberType+'</td><td>'+flag+'</td><td>'
							+item.memberShipAmount+'</td><td> <button type="button" class="btn btn-success btn-sm" value="'+item.memberId+'" id="edit"><span class="glyphicon">&#xe065;</span></button>'+
								' <button type="button" class="btn btn-danger btn-sm" value="'+item.memberId+'" id="delete"><span class="glyphicon">&#xe020;</span></button> <button type="button" class="btn btn-info btn-sm" value="'+item.memberId+'" id="print"><span class="glyphicon glyphicon-print"></span></button></td></tr>';
     		      }); 
				   $('#totalMembershipAmount').empty();

				   $('#totalMembershipAmount').append('( Total Membership Amount : '+totalMembershipAmount +' )');
				   
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
		
        var memberId = $(this).val();
		showDeleteConfirmModal("Delete this member?", function () {
			$.ajax({
				  url: "/member/delete/"+memberId,		  			  
				  type: "GET",
				  contentType: "application/json",			  
				  beforeSend: function() {		  				
				}
			})
			.done(function(data){
	            alert('Member Deleted Successfully');
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

        var memberId = $(this).val();   
        $.ajax({
			  url: "/member/edit/"+memberId,		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
			$("#firstName").val(data.firstName);
			$("#lastName").val(data.lastName);
			$("#mobileNumber").val(data.mobileNumber);
			$("#fullAddress").val(data.fullAddress);
			$("#memberType").val(data.memberType);
			$("#memberShipAmount").val(data.memberShipAmount);
			if(data.memberShipFlag == true) {
				$("#memberShipFlag").val('true');
			} else {
				$("#memberShipFlag").val('false');
			}
			
			$("#memberId").val(data.memberId);
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
        var firstName = $("#firstName").val();
        var lastName = $("#lastName").val();
        var mobileNumber = $("#mobileNumber").val();
        var fullAddress = $("#fullAddress").val();
		var memberShipFlag = $("#memberShipFlag").val();
		var memberShipAmount = $("#memberShipAmount").val();
		var memberType = $("#memberType").val();
		var memberId = $("#memberId").val();


        var payload={
        		'firstName':firstName,
        		'lastName':lastName,
        		'mobileNumber':mobileNumber,
        		'memberShipFlag':memberShipFlag,
				'memberType':memberType,
				'memberShipAmount':memberShipAmount,
				'fullAddress':fullAddress,
				'memberId': memberId
        		
         };
		 if(payload.firstName == '' || payload.firstName == null || payload.firstName == undefined ||
		 payload.lastName == '' || payload.lastName == null || payload.lastName == undefined ||
		 payload.mobileNumber == '' || payload.mobileNumber == null || payload.mobileNumber == undefined ||
		 payload.memberShipFlag == '' || payload.memberShipFlag == null || payload.memberShipFlag == undefined || 
		 payload.memberType == '' || payload.memberType == null || payload.memberType == undefined ||
		 payload.memberShipAmount == '' || payload.memberShipAmount == null || payload.memberShipAmount == undefined ||
		 payload.fullAddress == '' || payload.fullAddress == null || payload.fullAddress == undefined) {
			alert('Fill all fields in form');
			return false;

		 }
        $.ajax({
			  url: "/member/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            alert('Updated Successfully');
			$("#firstName").val('');
			$("#lastName").val('');
			$("#mobileNumber").val('');
			$("#fullAddress").val('');
			$("#memberShipFlag").val('');
			$("#memberShipAmount").val('');
			$("#memberType").val('');
			$("#memberId").val('');
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
		
		});
	
    });

	$('body').on('click', '#print', function() {  
		var id = $(this).val();   
		window.open("membershipCard/"+id);	
	
    });
});


</script>


<a href="/member/downloadExcel" class="btn btn-info" role="button">Download Excel</a>

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
