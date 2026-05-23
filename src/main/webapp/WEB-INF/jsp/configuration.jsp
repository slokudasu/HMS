<!DOCTYPE html>
<%
boolean isAdminUser = false;
Object adminValue = session != null ? session.getAttribute("restaurantIsAdmin") : null;
if (adminValue instanceof Boolean) {
  isAdminUser = ((Boolean) adminValue).booleanValue();
} else if (adminValue != null) {
  isAdminUser = "true".equalsIgnoreCase(String.valueOf(adminValue).trim());
}
%>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Restaurant Admin</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="/css/bootstrap.min.css" />

    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>

    <style>
      :root {
        --cfg-purple-50: #f5edff;
        --cfg-purple-100: #ede2ff;
        --cfg-purple-200: #d9c2ff;
        --cfg-purple-500: #7a3df0;
        --cfg-purple-600: #6b2fd4;
        --cfg-purple-700: #5a23b1;
      }

      html,
      body {
        height: 100%;
      }

      body {
        margin: 0;
        background: #f7f2ff;
      }

      .container {
        width: 100%;
        max-width: none;
        min-height: 100%;
        padding: 12px 14px 20px;
      }

      .configuration-tabs-wrap {
        width: 100%;
        overflow-x: auto;
        overflow-y: hidden;
        margin-bottom: 6px;
        -webkit-overflow-scrolling: touch;
      }

      .configuration-tabs.nav-tabs {
        display: flex;
        flex-wrap: nowrap;
        min-width: max-content;
        border-bottom: 1px solid var(--cfg-purple-200);
      }

      .configuration-tabs.nav-tabs > li {
        float: none;
      }

      .configuration-tabs.nav-tabs > li > a {
        margin-right: 8px;
        color: var(--cfg-purple-700);
        background-color: var(--cfg-purple-50);
        border: 1px solid var(--cfg-purple-200);
        border-radius: 10px 10px 0 0;
      }

      .configuration-tabs.nav-tabs > li > a:hover,
      .configuration-tabs.nav-tabs > li > a:focus {
        background-color: var(--cfg-purple-100);
        color: var(--cfg-purple-700);
      }

      .configuration-tabs.nav-tabs > li.active > a,
      .configuration-tabs.nav-tabs > li.active > a:hover,
      .configuration-tabs.nav-tabs > li.active > a:focus {
        background-color: var(--cfg-purple-600);
        border-color: var(--cfg-purple-600);
        color: #ffffff;
      }

      .panel.panel-primary {
        border-color: var(--cfg-purple-500);
      }

      .panel-primary > .panel-heading {
        background-color: var(--cfg-purple-600);
        border-color: var(--cfg-purple-600);
        color: #ffffff;
      }

      .panel-primary > .panel-heading label {
        color: #ffffff;
        margin: 0;
      }

      .panel-primary > .panel-heading .btn-info {
        background-color: rgba(255, 255, 255, 0.2);
        border-color: rgba(255, 255, 255, 0.35);
        color: #ffffff;
      }

      .panel-primary > .panel-heading .btn-info:hover,
      .panel-primary > .panel-heading .btn-info:focus {
        background-color: rgba(255, 255, 255, 0.3);
        border-color: rgba(255, 255, 255, 0.45);
        color: #ffffff;
      }

      .table > thead > tr > th {
        background-color: var(--cfg-purple-50);
        color: var(--cfg-purple-700);
        border-color: var(--cfg-purple-200);
      }

      .form-control:focus {
        border-color: var(--cfg-purple-500);
        box-shadow: 0 0 0 0.2rem rgba(122, 61, 240, 0.2);
      }

      .modal-header {
        background-color: var(--cfg-purple-50);
        border-bottom: 1px solid var(--cfg-purple-200);
      }

      .modal-header h4 {
        color: var(--cfg-purple-700);
      }

      .tab-content {
        margin-top: 20px;
      }

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
        .container {
          padding: 10px 10px 16px;
        }

        .configuration-tabs.nav-tabs > li > a {
          padding: 8px 12px;
          margin-right: 6px;
        }

        .delete-confirm-modal .modal-dialog {
          top: 10px;
          width: calc(100% - 16px);
        }
      }
    </style>
  </head>

  <body>

    <div class="col-md-3" id="alertBox" style="
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 250px;">
    </div>


    <div class="container">
      <!-- NAV TABS -->
      <div class="configuration-tabs-wrap">
        <ul class="nav nav-tabs configuration-tabs">
		  <li class="active"><a data-toggle="tab" href="#hall">Room / Hall</a></li>
          <li><a data-toggle="tab" href="#addTable">Tables</a></li>
          <li><a data-toggle="tab" href="#category">Menu Category</a></li>
          <li><a data-toggle="tab" href="#item">Items</a></li>
          <li><a data-toggle="tab" href="#subitem">Sub Items</a></li>
          <li><a data-toggle="tab" href="#orders">Orders</a></li>
          <% if (isAdminUser) { %>
          <li><a data-toggle="tab" href="#subscription">Subscriptions</a></li>
          <li><a data-toggle="tab" href="#subscriptionPayments">Payment Details</a></li>
          <li><a data-toggle="tab" href="#subscriptionAmountConfig">Subscription Amounts</a></li>
          <% } %>
        </ul>
      </div>

      <!-- TAB CONTENT -->
      <div class="tab-content">

		 <div id="hall" class="tab-pane fade in active">
			<div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <a href="rest" class="btn btn-info btn-sm">
                  <span class="glyphicon glyphicon-home"></span>
                </a>
                Room / Hall
              </div>
              <div class="panel-body">
                <div class="form-group col-md-3">
                  <label for="amount">Room / Hall Type</label>
                  <input
                    type="text"
                    class="form-control"
                    id="hallType"
                    name="hallType"
					placeholder="Rool or Hall"
                  />
                </div>

				<div class="form-group col-md-3">
                  <label>Status</label>
					<select id="hallStatus" class="form-control">
						<option value="ACTIVE">ACTIVE</option>
						<option value="INACTIVE">INACTIVE</option>
					</select>
                </div>

                <div class="form-group col-md-12">
                  <button
                    type="button"
                    class="btn btn-success"
                    onclick="saveHall()"
                    id="saveHall"
                  >
                    Save
                  </button>
                </div>

                <span id="" style="display:none; color:blue; margin-left:10px;">
                    Please wait... Saving hall details
                </span>

                <div id="loaderMsg" style="display:none; margin-top:10px; color:#337ab7;">
                  <span class="glyphicon glyphicon-refresh glyphicon-spin"></span>
                  Saving hall details...
                </div>

              </div>
            </div>
          </div>

      <div class="col-md-12">
			<div class="panel panel-primary">
				<div class="panel-heading"><label>Room / Hall Details</label></div>
					<div class="panel-body"> 
						<div class="table-responsive">          
							<table class="table-bordered table-striped table table-hover" >
								<thead>
									<tr>
										<th>Sl.No</th>
										<th>Room / Hall Type</th>
										<th>Status</th>	
										<th>Actions</th>						
									</tr>
								</thead>  
								<tbody id="roomTable"></tbody>
							</table>				
						</div>
				</div>
			</div>


      <!-- ================= MODAL ================= -->
    <div id="editHallModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4>Edit Room / Hall Type</h4>
          </div>

        <div class="modal-body">
            <div class="row">
              <input type="hidden" id="editHallId" />

              <div class="form-group col-md-4">
                <label>Room / Hall Type</label>
                <input type="text" id="editHallType" class="form-control" />
              </div>

              <div class="form-group col-md-3">
                <label>Status</label>
                <select id="editHallStatus" class="form-control">
                  <option value="ACTIVE">ACTIVE</option>
                  <option value="INACTIVE">INACTIVE</option>
                </select>
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-success" onclick="updateHall()">
              Update
            </button>
            <button class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        
        </div>
      </div>
    </div>

		</div>
		 </div>

        <!-- CATEGORY -->
        <div id="category" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <a href="rest" class="btn btn-info btn-sm">
                  <span class="glyphicon glyphicon-home"></span>
                </a>
                Menu Category
              </div>
              <div class="panel-body">
                <div class="form-group col-md-3">
                  <label for="amount">Menu Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="catName"
                    name="catName"
					placeholder="Starters"
                  />
                </div>

				<div class="form-group col-md-3">
                  <label>Status</label>
					<select id="catStatus" class="form-control">
						<option value="ACTIVE">ACTIVE</option>
						<option value="INACTIVE">INACTIVE</option>
					</select>
                </div>

                <div class="form-group col-md-12">
                  <button
                    type="button"
                    class="btn btn-success"
                    onclick="saveCategory()"
                    id="saveCategoryBtn"
                  >
                    Save
                  </button>
                </div>
              </div>
            </div>
          </div>

      <div class="col-md-12">
			<div class="panel panel-primary">
				<div class="panel-heading">Menu Category Details</label></div>
					<div class="panel-body"> 
						<div class="table-responsive">          
							<table class="table-bordered table-striped table table-hover" >
								<thead>
									<tr>
										<th>Sl.No</th>
										<th>Menu Name</th>
										<th>Status</th>	
										<th>Actions</th>						
									</tr>
								</thead>  
								<tbody id="tbdata"></tbody>
							</table>				
						</div>
				</div>
			</div>
		</div>

<!-- ================= MODAL ================= -->
<div id="editMenuCategory" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4>Edit Menu Category</h4>
      </div>

		<div class="modal-body">
				<div class="row">
					<input type="hidden" id="editId" />

					<div class="form-group col-md-4">
						<label>Menu Name</label>
						<input type="text" id="editName" class="form-control" />
					</div>

					<div class="form-group col-md-3">
						<label>Status</label>
						<select id="editStatus" class="form-control">
							<option value="ACTIVE">ACTIVE</option>
							<option value="INACTIVE">INACTIVE</option>
						</select>
					</div>
				</div>
	  	</div>

      <div class="modal-footer">
        <button class="btn btn-success" onclick="updateCategory()">
          Update
        </button>
        <button class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
	  
    </div>
  </div>
</div>


</div>


        <!-- ITEM -->
        <div id="item" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <a href="rest" class="btn btn-info btn-sm">
                  <span class="glyphicon glyphicon-home"></span>
                </a>
                Items
              </div>
              <div class="panel-body">
                <div class="form-group col-md-3">
                  <label>Menu Category</label>
                  <select id="itemCategoryId" class="form-control">
                    <option value="">Select Category</option>
                  </select>
                </div>

                <div class="form-group col-md-3">
                  <label>Item Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="itemName"
                    placeholder="Paneer Tikka"
                  />
                </div>

                <div class="form-group col-md-2">
                  <label>Price</label>
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    class="form-control"
                    id="itemPrice"
                    placeholder="0.00"
                  />
                </div>

                <div class="form-group col-md-2">
                  <label>Status</label>
                  <select id="itemStatus" class="form-control">
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="INACTIVE">INACTIVE</option>
                  </select>
                </div>

                <div class="form-group col-md-12">
                  <label>Description</label>
                  <input
                    type="text"
                    class="form-control"
                    id="itemDescription"
                    placeholder="Optional description"
                  />
                </div>

                <div class="form-group col-md-12">
                  <button
                    type="button"
                    class="btn btn-success"
                    id="saveItemBtn"
                    onclick="saveItem()"
                  >
                    Save
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">Item Details</div>
              <div class="panel-body">
                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Category</th>
                        <th>Item Name</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="itemData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div id="editItemModal" class="modal fade">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h4>Edit Item</h4>
                </div>

                <div class="modal-body">
                  <div class="row">
                    <input type="hidden" id="editItemId" />

                    <div class="form-group col-md-4">
                      <label>Menu Category</label>
                      <select id="editItemCategoryId" class="form-control">
                        <option value="">Select Category</option>
                      </select>
                    </div>

                    <div class="form-group col-md-4">
                      <label>Item Name</label>
                      <input type="text" id="editItemName" class="form-control" />
                    </div>

                    <div class="form-group col-md-3">
                      <label>Price</label>
                      <input
                        type="number"
                        min="0"
                        step="0.01"
                        id="editItemPrice"
                        class="form-control"
                      />
                    </div>

                    <div class="form-group col-md-3">
                      <label>Status</label>
                      <select id="editItemStatus" class="form-control">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                      </select>
                    </div>

                    <div class="form-group col-md-12">
                      <label>Description</label>
                      <input
                        type="text"
                        id="editItemDescription"
                        class="form-control"
                      />
                    </div>
                  </div>
                </div>

                <div class="modal-footer">
                  <button class="btn btn-success" onclick="updateItem()">
                    Update
                  </button>
                  <button class="btn btn-default" data-dismiss="modal">
                    Close
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- SUB ITEM -->
        <div id="subitem" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <a href="rest" class="btn btn-info btn-sm">
                  <span class="glyphicon glyphicon-home"></span>
                </a>
                Sub Items
              </div>
              <div class="panel-body">
                <div class="form-group col-md-3">
                  <label>Item</label>
                  <select id="subItemItemId" class="form-control">
                    <option value="">Select Item</option>
                  </select>
                </div>

                <div class="form-group col-md-3">
                  <label>Sub Item Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="subItemName"
                    placeholder="Half Plate"
                  />
                </div>

                <div class="form-group col-md-2">
                  <label>Price</label>
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    class="form-control"
                    id="subItemPrice"
                    placeholder="0.00"
                  />
                </div>

                <div class="form-group col-md-2">
                  <label>Status</label>
                  <select id="subItemStatus" class="form-control">
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="INACTIVE">INACTIVE</option>
                  </select>
                </div>

                <div class="form-group col-md-12">
                  <button
                    type="button"
                    class="btn btn-success"
                    id="saveSubItemBtn"
                    onclick="saveSubItem()"
                  >
                    Save
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">Sub Item Details</div>
              <div class="panel-body">
                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Item</th>
                        <th>Sub Item Name</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="subItemData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div id="editSubItemModal" class="modal fade">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h4>Edit Sub Item</h4>
                </div>

                <div class="modal-body">
                  <div class="row">
                    <input type="hidden" id="editSubItemId" />

                    <div class="form-group col-md-4">
                      <label>Item</label>
                      <select id="editSubItemItemId" class="form-control">
                        <option value="">Select Item</option>
                      </select>
                    </div>

                    <div class="form-group col-md-4">
                      <label>Sub Item Name</label>
                      <input
                        type="text"
                        id="editSubItemName"
                        class="form-control"
                      />
                    </div>

                    <div class="form-group col-md-3">
                      <label>Price</label>
                      <input
                        type="number"
                        min="0"
                        step="0.01"
                        id="editSubItemPrice"
                        class="form-control"
                      />
                    </div>

                    <div class="form-group col-md-3">
                      <label>Status</label>
                      <select id="editSubItemStatus" class="form-control">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="modal-footer">
                  <button class="btn btn-success" onclick="updateSubItem()">
                    Update
                  </button>
                  <button class="btn btn-default" data-dismiss="modal">
                    Close
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- TABLE -->
        <div id="addTable" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <a href="rest" class="btn btn-info btn-sm">
                  <span class="glyphicon glyphicon-home"></span>
                </a>
                Tables
              </div>
              <div class="panel-body">
                <div class="form-group col-md-3">
                  <label>Room / Hall</label>
                  <select id="tableHallId" class="form-control">
                    <option value="">Select Room / Hall</option>
                  </select>
                </div>

                <div class="form-group col-md-3">
                  <label>Table Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="tableName"
                    placeholder="T1"
                  />
                </div>

                <div class="form-group col-md-3">
                  <label>Status</label>
                  <select id="tableStatus" class="form-control">
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="INACTIVE">INACTIVE</option>
                  </select>
                </div>

                <div class="form-group col-md-12">
                  <button
                    type="button"
                    class="btn btn-success"
                    id="saveTableBtn"
                    onclick="saveTable()"
                  >
                    Save
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">Table Details</div>
              <div class="panel-body">
                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Room / Hall</th>
                        <th>Table Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="tableData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div id="editTableModal" class="modal fade">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h4>Edit Table</h4>
                </div>

                <div class="modal-body">
                  <div class="row">
                    <input type="hidden" id="editTableId" />

                    <div class="form-group col-md-4">
                      <label>Room / Hall</label>
                      <select id="editTableHallId" class="form-control">
                        <option value="">Select Room / Hall</option>
                      </select>
                    </div>

                    <div class="form-group col-md-4">
                      <label>Table Name</label>
                      <input
                        type="text"
                        id="editTableName"
                        class="form-control"
                      />
                    </div>

                    <div class="form-group col-md-3">
                      <label>Status</label>
                      <select id="editTableStatus" class="form-control">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="modal-footer">
                  <button class="btn btn-success" onclick="updateTable()">
                    Update
                  </button>
                  <button class="btn btn-default" data-dismiss="modal">
                    Close
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ORDERS -->
        <div id="orders" class="tab-pane fade">
          <h3>Orders</h3>
          <p>Orders UI here</p>
        </div>

        <% if (isAdminUser) { %>
        <!-- SUBSCRIPTIONS -->
        <div id="subscription" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">User Subscription Management</div>
              <div class="panel-body">
                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Restaurant</th>
                        <th>Mobile</th>
                        <th>Email</th>
                        <th>Plan</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="subscriptionData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

        </div>

        <div id="subscriptionPayments" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">Subscription Payment Details (Admin)</div>
              <div class="panel-body">
                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Restaurant</th>
                        <th>Mobile</th>
                        <th>Plan</th>
                        <th>Amount</th>
                        <th>Transaction ID</th>
                        <th>Payment Mode</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Paid At</th>
                      </tr>
                    </thead>
                    <tbody id="subscriptionPaymentData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div id="subscriptionAmountConfig" class="tab-pane fade">
          <div class="col-md-12">
            <div class="panel panel-primary">
              <div class="panel-heading">Subscription Amount Configuration</div>
              <div class="panel-body">
                <div class="row">
                  <div class="form-group col-md-3">
                    <label>Plan</label>
                    <select id="subscriptionAmountPlan" class="form-control">
                      <option value="MONTHLY">MONTHLY</option>
                      <option value="QUARTERLY">QUARTERLY</option>
                      <option value="HALF_YEARLY">HALF YEAR</option>
                      <option value="YEARLY">YEARLY</option>
                    </select>
                  </div>

                  <div class="form-group col-md-3">
                    <label>Amount</label>
                    <input
                      type="number"
                      min="0.01"
                      step="0.01"
                      id="subscriptionAmountValue"
                      class="form-control"
                      placeholder="0.00"
                    />
                  </div>

                  <div class="form-group col-md-12">
                    <button
                      type="button"
                      class="btn btn-success"
                      id="saveSubscriptionAmountBtn"
                      onclick="saveSubscriptionAmount()"
                    >
                      Save
                    </button>
                  </div>
                </div>

                <div class="table-responsive">
                  <table class="table-bordered table-striped table table-hover">
                    <thead>
                      <tr>
                        <th>Sl.No</th>
                        <th>Plan</th>
                        <th>Amount</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="subscriptionAmountData"></tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <% if (isAdminUser) { %>
    <div id="editSubscriptionModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4>Update Subscription</h4>
          </div>

          <div class="modal-body">
            <div class="row">
              <input type="hidden" id="editSubscriptionUserId" />

              <div class="form-group col-md-12">
                <label>Restaurant</label>
                <input type="text" id="editSubscriptionRestaurantName" class="form-control" readonly />
              </div>

              <div class="form-group col-md-6">
                <label>Plan</label>
                <select id="editSubscriptionPlan" class="form-control">
                  <option value="MONTHLY">MONTHLY</option>
                  <option value="QUARTERLY">QUARTERLY</option>
                  <option value="HALF_YEARLY">HALF YEAR</option>
                  <option value="YEARLY">YEARLY</option>
                </select>
              </div>

              <div class="form-group col-md-6">
                <label>Start Date</label>
                <input type="date" id="editSubscriptionStartDate" class="form-control" />
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-success" id="updateSubscriptionBtn" onclick="updateSubscription()">
              Update
            </button>
            <button class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    <div id="editSubscriptionAmountModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4>Update Subscription Amount</h4>
          </div>

          <div class="modal-body">
            <div class="row">
              <input type="hidden" id="editSubscriptionAmountId" />

              <div class="form-group col-md-6">
                <label>Plan</label>
                <select id="editSubscriptionAmountPlan" class="form-control">
                  <option value="MONTHLY">MONTHLY</option>
                  <option value="QUARTERLY">QUARTERLY</option>
                  <option value="HALF_YEARLY">HALF YEAR</option>
                  <option value="YEARLY">YEARLY</option>
                </select>
              </div>

              <div class="form-group col-md-6">
                <label>Amount</label>
                <input
                  type="number"
                  min="0.01"
                  step="0.01"
                  id="editSubscriptionAmountValue"
                  class="form-control"
                />
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-success" id="updateSubscriptionAmountBtn" onclick="updateSubscriptionAmount()">
              Update
            </button>
            <button class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <% } %>

    <div id="deleteConfirmModal" class="modal delete-confirm-modal" role="dialog">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Delete Confirmation</h4>
          </div>
          <div class="modal-body">
            <p id="deleteConfirmMessage" class="mb-0">Are you sure you want to delete?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-danger" id="deleteConfirmOkBtn">Delete</button>
          </div>
        </div>
      </div>
    </div>

    <script>
      var isAdminUser = <%= isAdminUser ? "true" : "false" %>;

      function showMessage(message, type) {
        var alertClass = "alert-success";
        if (type === "error") {
          alertClass = "alert-danger";
        } else if (type === "warning") {
          alertClass = "alert-warning";
        }

        var html =
          '<div class="alert ' +
          alertClass +
          '"><strong>' +
          message +
          "</strong></div>";
        $("#alertBox").html(html);

        setTimeout(function () {
          $("#alertBox").html("");
        }, 3000);
      }

      function extractErrorMessage(jqXHR, fallbackMessage) {
        if (jqXHR && jqXHR.responseJSON) {
          if (jqXHR.responseJSON.message) return jqXHR.responseJSON.message;
          if (jqXHR.responseJSON.errorMessage)
            return jqXHR.responseJSON.errorMessage;
          if (jqXHR.responseJSON.error) return jqXHR.responseJSON.error;
        }

        if (jqXHR && jqXHR.responseText && jqXHR.responseText.trim() !== "") {
          return jqXHR.responseText;
        }

        return fallbackMessage;
      }

      function escapeHtml(value) {
        if (value === null || value === undefined) return "";
        return String(value)
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#39;");
      }

      function renderEmptyRow(targetId, colSpan, message) {
        $("#" + targetId).html(
          '<tr><td colspan="' +
            colSpan +
            '" class="text-center text-muted">' +
            escapeHtml(message) +
            "</td></tr>"
        );
      }

      function showDeleteConfirmModal(message, onConfirm) {
        var $modal = $("#deleteConfirmModal");
        var $confirmBtn = $("#deleteConfirmOkBtn");

        $("#deleteConfirmMessage").text(message || "Are you sure you want to delete?");

        $confirmBtn.off("click.deleteConfirm").on("click.deleteConfirm", function () {
          $modal.modal("hide");
          if (typeof onConfirm === "function") {
            onConfirm();
          }
        });

        $modal.off("hidden.bs.modal.deleteConfirm").on("hidden.bs.modal.deleteConfirm", function () {
          $confirmBtn.off("click.deleteConfirm");
        });

        $modal.modal("show");
      }

      function vailidation(value) {
        return !value || String(value).trim() === "";
      }

      function formatDateValue(value) {
        if (vailidation(value)) {
          return "-";
        }
        return escapeHtml(value);
      }

      function formatSubscriptionPlan(plan) {
        if (vailidation(plan)) {
          return "-";
        }
        if (plan === "HALF_YEARLY") {
          return "HALF YEAR";
        }
        return escapeHtml(String(plan).replace(/_/g, " "));
      }

      function loadSubscriptions() {
        if (!isAdminUser) {
          return;
        }

        $.ajax({
          url: "/restaurant-users/subscriptions",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#subscriptionData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                var subscriptionStatus =
                  item.subscriptionActive === true
                    ? '<span class="label label-success">ACTIVE</span>'
                    : '<span class="label label-danger">EXPIRED</span>';

                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.restaurantName || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.mobileNo || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.email || "-") +
                  "</td>" +
                  "<td>" +
                  formatSubscriptionPlan(item.subscriptionPlan) +
                  "</td>" +
                  "<td>" +
                  formatDateValue(item.subscriptionStartDate) +
                  "</td>" +
                  "<td>" +
                  formatDateValue(item.subscriptionEndDate) +
                  "</td>" +
                  "<td>" +
                  subscriptionStatus +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-subscription-btn" ' +
                  'data-id="' +
                  item.id +
                  '" data-restaurant-name="' +
                  escapeHtml(item.restaurantName || "") +
                  '" data-plan="' +
                  escapeHtml(item.subscriptionPlan || "MONTHLY") +
                  '" data-start-date="' +
                  escapeHtml(item.subscriptionStartDate || "") +
                  '" title="Update Subscription">' +
                  '<span class="glyphicon glyphicon-pencil"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#subscriptionData").append(trHTML);
              return;
            }

            renderEmptyRow("subscriptionData", 9, "No users found");
          })
          .fail(function (jqXHR) {
            renderEmptyRow("subscriptionData", 9, "Unable to load subscriptions");
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load subscriptions"),
              "error"
            );
          });
      }

      function loadSubscriptionDetails() {
        if (!isAdminUser) {
          return;
        }

        renderEmptyRow("subscriptionPaymentData", 10, "Loading subscription payment details...");

        $.ajax({
          url: "/restaurant-users/subscription-details",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#subscriptionPaymentData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.restaurantName || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.mobileNo || "-") +
                  "</td>" +
                  "<td>" +
                  formatSubscriptionPlan(item.subscriptionPlan) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.amount || "0.00") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.transactionId || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.paymentMode || "-") +
                  "</td>" +
                  "<td>" +
                  formatDateValue(item.subscriptionStartDate) +
                  "</td>" +
                  "<td>" +
                  formatDateValue(item.subscriptionEndDate) +
                  "</td>" +
                  "<td>" +
                  formatDateValue(item.paymentDate) +
                  "</td>" +
                  "</tr>";
              });
              $("#subscriptionPaymentData").append(trHTML);
              return;
            }

            renderEmptyRow("subscriptionPaymentData", 10, "No subscription payment details found");
          })
          .fail(function (jqXHR) {
            renderEmptyRow("subscriptionPaymentData", 10, "Unable to load subscription payment details");
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load subscription payment details"),
              "error"
            );
          });
      }

      function loadSubscriptionAmounts() {
        if (!isAdminUser) {
          return;
        }

        renderEmptyRow("subscriptionAmountData", 4, "Loading subscription amounts...");

        $.ajax({
          url: "/subscription-amounts",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#subscriptionAmountData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  formatSubscriptionPlan(item.subscriptionPlan) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(formatAmount(item.amount)) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-subscription-amount-btn" ' +
                  'data-id="' +
                  item.id +
                  '" data-plan="' +
                  escapeHtml(item.subscriptionPlan || "MONTHLY") +
                  '" data-amount="' +
                  escapeHtml(item.amount || "") +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-subscription-amount-btn" ' +
                  'data-id="' +
                  item.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#subscriptionAmountData").append(trHTML);
              return;
            }

            renderEmptyRow("subscriptionAmountData", 4, "No subscription amount configuration found");
          })
          .fail(function (jqXHR) {
            renderEmptyRow("subscriptionAmountData", 4, "Unable to load subscription amounts");
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load subscription amounts"),
              "error"
            );
          });
      }

      function saveSubscriptionAmount() {
        var subscriptionPlan = $("#subscriptionAmountPlan").val();
        var amount = parsePositiveAmount(
          $("#subscriptionAmountValue").val(),
          "Subscription amount",
          "#subscriptionAmountValue"
        );

        if (vailidation(subscriptionPlan)) {
          showMessage("Subscription plan is required", "error");
          $("#subscriptionAmountPlan").focus();
          return;
        }

        if (amount === null) {
          return;
        }

        var $saveBtn = $("#saveSubscriptionAmountBtn");
        $saveBtn.prop("disabled", true).text("Saving...");

        var payload = {
          subscriptionPlan: subscriptionPlan,
          amount: amount,
        };

        $.ajax({
          url: "/subscription-amounts",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(payload),
        })
          .done(function () {
            showMessage("Subscription amount saved successfully", "success");
            $("#subscriptionAmountPlan").val("MONTHLY");
            $("#subscriptionAmountValue").val("");
            loadSubscriptionAmounts();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save subscription amount"),
              "error"
            );
          })
          .always(function () {
            $saveBtn.prop("disabled", false).text("Save");
          });
      }

      function updateSubscriptionAmount() {
        var id = $("#editSubscriptionAmountId").val();
        var subscriptionPlan = $("#editSubscriptionAmountPlan").val();
        var amount = parsePositiveAmount(
          $("#editSubscriptionAmountValue").val(),
          "Subscription amount",
          "#editSubscriptionAmountValue"
        );

        if (!id) {
          showMessage("Invalid subscription amount selected", "error");
          return;
        }

        if (vailidation(subscriptionPlan)) {
          showMessage("Subscription plan is required", "error");
          $("#editSubscriptionAmountPlan").focus();
          return;
        }

        if (amount === null) {
          return;
        }

        var $updateBtn = $("#updateSubscriptionAmountBtn");
        $updateBtn.prop("disabled", true).text("Updating...");

        var payload = {
          subscriptionPlan: subscriptionPlan,
          amount: amount,
        };

        $.ajax({
          url: "/subscription-amounts/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(payload),
        })
          .done(function () {
            showMessage("Subscription amount updated successfully", "success");
            $("#editSubscriptionAmountModal").modal("hide");
            loadSubscriptionAmounts();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update subscription amount"),
              "error"
            );
          })
          .always(function () {
            $updateBtn.prop("disabled", false).text("Update");
          });
      }

      function updateSubscription() {
        var userId = $("#editSubscriptionUserId").val();
        var subscriptionPlan = $("#editSubscriptionPlan").val();
        var subscriptionStartDate = $("#editSubscriptionStartDate").val();

        if (!userId) {
          showMessage("Invalid user selected", "error");
          return;
        }

        if (vailidation(subscriptionPlan)) {
          showMessage("Subscription plan is required", "error");
          $("#editSubscriptionPlan").focus();
          return;
        }

        if (vailidation(subscriptionStartDate)) {
          showMessage("Subscription start date is required", "error");
          $("#editSubscriptionStartDate").focus();
          return;
        }

        var $updateBtn = $("#updateSubscriptionBtn");
        $updateBtn.prop("disabled", true).text("Updating...");

        var payload = {
          subscriptionPlan: subscriptionPlan,
          subscriptionStartDate: subscriptionStartDate,
        };

        $.ajax({
          url: "/restaurant-users/" + userId + "/subscription",
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(payload),
        })
          .done(function () {
            showMessage("Subscription updated successfully", "success");
            $("#editSubscriptionModal").modal("hide");
            loadSubscriptions();
            loadSubscriptionDetails();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update subscription"),
              "error"
            );
          })
          .always(function () {
            $updateBtn.prop("disabled", false).text("Update");
          });
      }

      function saveCategory() {
        var name = $("#catName").val();
        if (vailidation(name)) {
          showMessage("Menu Name is required", "error");
          $("#catName").focus();
          return;
        }

        var $saveBtn = $("#saveCategoryBtn");
        $saveBtn.prop("disabled", true).text("Saving...");

        var data = {
          name: name.trim(),
          status: $("#catStatus").val(),
        };

        $.ajax({
          url: "/menu-category",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Saved Successfully", "success");
            $("#catName").val("");
            $("#catStatus").val("ACTIVE");
            loadCategories();
            loadItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save menu category"),
              "error"
            );
          })
          .always(function () {
            $saveBtn.prop("disabled", false).text("Save");
          });
      }

      function loadCategories() {
        $.ajax({
          url: "/menu-category",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#tbdata").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.name) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.status) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-category-btn" value="' +
                  item.id +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-category-btn" value="' +
                  item.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#tbdata").append(trHTML);
              populateCategoryDropdowns(data);
              return;
            }

            renderEmptyRow("tbdata", 4, "No menu categories found");
            populateCategoryDropdowns([]);
          })
          .fail(function (jqXHR) {
            renderEmptyRow("tbdata", 4, "Unable to load menu categories");
            populateCategoryDropdowns([]);
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load menu categories"),
              "error"
            );
          });
      }

      function formatAmount(value) {
        var amount = Number(value);
        if (Number.isNaN(amount)) {
          return "-";
        }
        return amount.toFixed(2);
      }

      function parseAmount(value, label, inputSelector) {
        if (vailidation(value)) {
          showMessage(label + " is required", "error");
          $(inputSelector).focus();
          return null;
        }

        var amount = parseFloat(value);
        if (Number.isNaN(amount) || amount < 0) {
          showMessage(label + " must be zero or greater", "error");
          $(inputSelector).focus();
          return null;
        }

        return amount;
      }

      function parsePositiveAmount(value, label, inputSelector) {
        var amount = parseAmount(value, label, inputSelector);
        if (amount === null) {
          return null;
        }
        if (amount <= 0) {
          showMessage(label + " must be greater than zero", "error");
          $(inputSelector).focus();
          return null;
        }
        return amount;
      }

      function populateCategoryDropdowns(categories) {
        var selectedCreateCategory = $("#itemCategoryId").val();
        var selectedEditCategory = $("#editItemCategoryId").val();

        var createOptions = '<option value="">Select Category</option>';
        var editOptions = '<option value="">Select Category</option>';

        if (Array.isArray(categories) && categories.length > 0) {
          $.each(categories, function (index, category) {
            var label =
              escapeHtml(category.name) + " (" + escapeHtml(category.status) + ")";
            createOptions +=
              '<option value="' + category.id + '">' + label + "</option>";
            editOptions +=
              '<option value="' + category.id + '">' + label + "</option>";
          });
        }

        $("#itemCategoryId").html(createOptions);
        $("#editItemCategoryId").html(editOptions);

        if (selectedCreateCategory) {
          $("#itemCategoryId").val(selectedCreateCategory);
        }
        if (selectedEditCategory) {
          $("#editItemCategoryId").val(selectedEditCategory);
        }
      }

      function populateItemDropdowns(items) {
        var selectedCreateItem = $("#subItemItemId").val();
        var selectedEditItem = $("#editSubItemItemId").val();

        var createOptions = '<option value="">Select Item</option>';
        var editOptions = '<option value="">Select Item</option>';

        if (Array.isArray(items) && items.length > 0) {
          $.each(items, function (index, item) {
            var label =
              escapeHtml(item.name) + " - " + escapeHtml(item.categoryName || "");
            createOptions +=
              '<option value="' + item.id + '">' + label + "</option>";
            editOptions +=
              '<option value="' + item.id + '">' + label + "</option>";
          });
        }

        $("#subItemItemId").html(createOptions);
        $("#editSubItemItemId").html(editOptions);

        if (selectedCreateItem) {
          $("#subItemItemId").val(selectedCreateItem);
        }
        if (selectedEditItem) {
          $("#editSubItemItemId").val(selectedEditItem);
        }
      }

      function loadItems() {
        $.ajax({
          url: "/menu-items",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#itemData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.categoryName || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.name) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(formatAmount(item.price)) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.status) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-item-btn" value="' +
                  item.id +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-item-btn" value="' +
                  item.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#itemData").append(trHTML);
              populateItemDropdowns(data);
              return;
            }

            renderEmptyRow("itemData", 6, "No items found");
            populateItemDropdowns([]);
          })
          .fail(function (jqXHR) {
            renderEmptyRow("itemData", 6, "Unable to load items");
            populateItemDropdowns([]);
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load items"),
              "error"
            );
          });
      }

      function saveItem() {
        var categoryId = $("#itemCategoryId").val();
        var name = $("#itemName").val();
        var description = $("#itemDescription").val();
        var price = parseAmount($("#itemPrice").val(), "Item price", "#itemPrice");

        if (vailidation(categoryId)) {
          showMessage("Menu Category is required", "error");
          $("#itemCategoryId").focus();
          return;
        }

        if (vailidation(name)) {
          showMessage("Item name is required", "error");
          $("#itemName").focus();
          return;
        }

        if (price === null) {
          return;
        }

        var $saveBtn = $("#saveItemBtn");
        $saveBtn.prop("disabled", true).text("Saving...");

        var data = {
          categoryId: parseInt(categoryId, 10),
          name: name.trim(),
          description: vailidation(description) ? "" : description.trim(),
          price: price,
          status: $("#itemStatus").val(),
        };

        $.ajax({
          url: "/menu-items",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Item saved successfully", "success");
            $("#itemName").val("");
            $("#itemDescription").val("");
            $("#itemPrice").val("");
            $("#itemStatus").val("ACTIVE");
            loadItems();
            loadSubItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save item"),
              "error"
            );
          })
          .always(function () {
            $saveBtn.prop("disabled", false).text("Save");
          });
      }

      function updateItem() {
        var id = $("#editItemId").val();
        var categoryId = $("#editItemCategoryId").val();
        var name = $("#editItemName").val();
        var description = $("#editItemDescription").val();
        var price = parseAmount(
          $("#editItemPrice").val(),
          "Item price",
          "#editItemPrice"
        );

        if (!id) {
          showMessage("Invalid item selected", "error");
          return;
        }

        if (vailidation(categoryId)) {
          showMessage("Menu Category is required", "error");
          $("#editItemCategoryId").focus();
          return;
        }

        if (vailidation(name)) {
          showMessage("Item name is required", "error");
          $("#editItemName").focus();
          return;
        }

        if (price === null) {
          return;
        }

        var data = {
          categoryId: parseInt(categoryId, 10),
          name: name.trim(),
          description: vailidation(description) ? "" : description.trim(),
          price: price,
          status: $("#editItemStatus").val(),
        };

        $.ajax({
          url: "/menu-items/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Updated Successfully", "success");
            $("#editItemModal").modal("hide");
            loadItems();
            loadSubItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update item"),
              "error"
            );
          });
      }

      function loadSubItems() {
        $.ajax({
          url: "/sub-items",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#subItemData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, subItem) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(subItem.itemName || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(subItem.name) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(formatAmount(subItem.price)) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(subItem.status) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-subitem-btn" value="' +
                  subItem.id +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-subitem-btn" value="' +
                  subItem.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#subItemData").append(trHTML);
              return;
            }

            renderEmptyRow("subItemData", 6, "No sub items found");
          })
          .fail(function (jqXHR) {
            renderEmptyRow("subItemData", 6, "Unable to load sub items");
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load sub items"),
              "error"
            );
          });
      }

      function saveSubItem() {
        var itemId = $("#subItemItemId").val();
        var name = $("#subItemName").val();
        var price = parseAmount(
          $("#subItemPrice").val(),
          "Sub item price",
          "#subItemPrice"
        );

        if (vailidation(itemId)) {
          showMessage("Item is required", "error");
          $("#subItemItemId").focus();
          return;
        }

        if (vailidation(name)) {
          showMessage("Sub item name is required", "error");
          $("#subItemName").focus();
          return;
        }

        if (price === null) {
          return;
        }

        var $saveBtn = $("#saveSubItemBtn");
        $saveBtn.prop("disabled", true).text("Saving...");

        var data = {
          itemId: parseInt(itemId, 10),
          name: name.trim(),
          price: price,
          status: $("#subItemStatus").val(),
        };

        $.ajax({
          url: "/sub-items",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Sub item saved successfully", "success");
            $("#subItemName").val("");
            $("#subItemPrice").val("");
            $("#subItemStatus").val("ACTIVE");
            loadSubItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save sub item"),
              "error"
            );
          })
          .always(function () {
            $saveBtn.prop("disabled", false).text("Save");
          });
      }

      function updateSubItem() {
        var id = $("#editSubItemId").val();
        var itemId = $("#editSubItemItemId").val();
        var name = $("#editSubItemName").val();
        var price = parseAmount(
          $("#editSubItemPrice").val(),
          "Sub item price",
          "#editSubItemPrice"
        );

        if (!id) {
          showMessage("Invalid sub item selected", "error");
          return;
        }

        if (vailidation(itemId)) {
          showMessage("Item is required", "error");
          $("#editSubItemItemId").focus();
          return;
        }

        if (vailidation(name)) {
          showMessage("Sub item name is required", "error");
          $("#editSubItemName").focus();
          return;
        }

        if (price === null) {
          return;
        }

        var data = {
          itemId: parseInt(itemId, 10),
          name: name.trim(),
          price: price,
          status: $("#editSubItemStatus").val(),
        };

        $.ajax({
          url: "/sub-items/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Updated Successfully", "success");
            $("#editSubItemModal").modal("hide");
            loadSubItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update sub item"),
              "error"
            );
          });
      }

      function loadHalls() {
        $.ajax({
          url: "/rooms",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#roomTable").empty();

            if (Array.isArray(data) && data.length > 0) {
              populateHallDropdowns(data);
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.name) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.status) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-hall-btn" value="' +
                  item.id +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-hall-btn" value="' +
                  item.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#roomTable").append(trHTML);
              return;
            }

            renderEmptyRow("roomTable", 4, "No rooms / halls found");
            populateHallDropdowns([]);
          })
          .fail(function (jqXHR) {
            renderEmptyRow("roomTable", 4, "Unable to load rooms / halls");
            populateHallDropdowns([]);
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load rooms / halls"),
              "error"
            );
          });
      }

      function populateHallDropdowns(halls) {
        var selectedCreateHall = $("#tableHallId").val();
        var selectedEditHall = $("#editTableHallId").val();

        var createOptions = '<option value="">Select Room / Hall</option>';
        var editOptions = '<option value="">Select Room / Hall</option>';

        if (Array.isArray(halls) && halls.length > 0) {
          $.each(halls, function (index, hall) {
            var label = escapeHtml(hall.name) + " (" + escapeHtml(hall.status) + ")";
            createOptions +=
              '<option value="' + hall.id + '">' + label + "</option>";
            editOptions +=
              '<option value="' + hall.id + '">' + label + "</option>";
          });
        }

        $("#tableHallId").html(createOptions);
        $("#editTableHallId").html(editOptions);

        if (selectedCreateHall) {
          $("#tableHallId").val(selectedCreateHall);
        }
        if (selectedEditHall) {
          $("#editTableHallId").val(selectedEditHall);
        }
      }

      function loadTables() {
        $.ajax({
          url: "/tables",
          type: "GET",
          contentType: "application/json",
        })
          .done(function (data) {
            var trHTML = "";
            $("#tableData").empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                var insNo = index + 1;
                trHTML +=
                  "<tr>" +
                  "<td>" +
                  insNo +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.hallName || "-") +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.tableName) +
                  "</td>" +
                  "<td>" +
                  escapeHtml(item.status) +
                  "</td>" +
                  "<td>" +
                  '<button type="button" class="btn btn-success btn-sm edit-table-btn" value="' +
                  item.id +
                  '" title="Edit"><span class="glyphicon glyphicon-pencil"></span></button> ' +
                  '<button type="button" class="btn btn-danger btn-sm delete-table-btn" value="' +
                  item.id +
                  '" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>' +
                  "</td>" +
                  "</tr>";
              });
              $("#tableData").append(trHTML);
              return;
            }

            renderEmptyRow("tableData", 5, "No tables found");
          })
          .fail(function (jqXHR) {
            renderEmptyRow("tableData", 5, "Unable to load tables");
            showMessage(
              extractErrorMessage(jqXHR, "Unable to load tables"),
              "error"
            );
          });
      }

      function saveTable() {
        var hallId = $("#tableHallId").val();
        var tableName = $("#tableName").val();

        if (vailidation(hallId)) {
          showMessage("Room / Hall is required", "error");
          $("#tableHallId").focus();
          return;
        }

        if (vailidation(tableName)) {
          showMessage("Table name is required", "error");
          $("#tableName").focus();
          return;
        }

        var $saveBtn = $("#saveTableBtn");
        $saveBtn.prop("disabled", true).text("Saving...");

        var data = {
          hallId: parseInt(hallId, 10),
          tableName: tableName.trim(),
          status: $("#tableStatus").val(),
        };

        $.ajax({
          url: "/tables",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Table saved successfully", "success");
            $("#tableName").val("");
            $("#tableStatus").val("ACTIVE");
            loadTables();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save table"),
              "error"
            );
          })
          .always(function () {
            $saveBtn.prop("disabled", false).text("Save");
          });
      }

      function updateTable() {
        var id = $("#editTableId").val();
        var hallId = $("#editTableHallId").val();
        var tableName = $("#editTableName").val();

        if (!id) {
          showMessage("Invalid table selected", "error");
          return;
        }

        if (vailidation(hallId)) {
          showMessage("Room / Hall is required", "error");
          $("#editTableHallId").focus();
          return;
        }

        if (vailidation(tableName)) {
          showMessage("Table name is required", "error");
          $("#editTableName").focus();
          return;
        }

        var data = {
          hallId: parseInt(hallId, 10),
          tableName: tableName.trim(),
          status: $("#editTableStatus").val(),
        };

        $.ajax({
          url: "/tables/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Updated Successfully", "success");
            $("#editTableModal").modal("hide");
            loadTables();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update table"),
              "error"
            );
          });
      }

      function updateCategory() {
        var id = $("#editId").val();
        var name = $("#editName").val();

        if (!id) {
          showMessage("Invalid category selected", "error");
          return;
        }

        if (vailidation(name)) {
          showMessage("Menu Name is required", "error");
          $("#editName").focus();
          return;
        }

        var data = {
          name: name.trim(),
          status: $("#editStatus").val(),
        };

        $.ajax({
          url: "/menu-category/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Updated Successfully", "success");
            $("#editMenuCategory").modal("hide");
            loadCategories();
            loadItems();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update menu category"),
              "error"
            );
          });
      }

      function updateHall() {
        var id = $("#editHallId").val();
        var name = $("#editHallType").val();

        if (!id) {
          showMessage("Invalid room / hall selected", "error");
          return;
        }

        if (vailidation(name)) {
          showMessage("Room / Hall Type is required", "error");
          $("#editHallType").focus();
          return;
        }

        var data = {
          name: name.trim(),
          status: $("#editHallStatus").val(),
        };

        $.ajax({
          url: "/rooms/" + id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
        })
          .done(function () {
            showMessage("Updated Successfully", "success");
            $("#editHallModal").modal("hide");
            loadHalls();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to update room / hall"),
              "error"
            );
          });
      }

      function saveHall() {
        var name = $("#hallType").val();
        if (vailidation(name)) {
          showMessage("Room / Hall Type is required", "error");
          $("#hallType").focus();
          return;
        }

        var data = {
          name: name.trim(),
          status: $("#hallStatus").val(),
        };

        $("#saveHall").prop("disabled", true).text("Saving...");

        $.ajax({
          url: "/rooms",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
          beforeSend: function () {
            $("#loaderMsg").show();
          },
        })
          .done(function () {
            showMessage("Saved successfully!", "success");
            $("#hallType").val("");
            $("#hallStatus").val("ACTIVE");
            loadHalls();
          })
          .fail(function (jqXHR) {
            showMessage(
              extractErrorMessage(jqXHR, "Unable to save room / hall"),
              "error"
            );
          })
          .always(function () {
            $("#loaderMsg").hide();
            $("#saveHall").prop("disabled", false).text("Save");
          });
      }

      $(document).ready(function () {
        loadCategories();
        loadItems();
        loadSubItems();
        loadHalls();
        loadTables();
        if (isAdminUser) {
          loadSubscriptions();
          loadSubscriptionDetails();
          loadSubscriptionAmounts();
        }

        $("body").on("click", ".delete-category-btn", function () {
          var id = $(this).val();
          showDeleteConfirmModal("Delete this category?", function () {
            $.ajax({
              url: "/menu-category/" + id,
              type: "DELETE",
              contentType: "application/json",
            })
              .done(function () {
                showMessage("Deleted Successfully", "success");
                loadCategories();
                loadItems();
              })
              .fail(function (jqXHR) {
                showMessage(
                  extractErrorMessage(jqXHR, "Unable to delete menu category"),
                  "error"
                );
              });
            });
          });

        $("body").on("click", ".delete-hall-btn", function () {
          var id = $(this).val();
          showDeleteConfirmModal("Delete this Hall/Room?", function () {
            $.ajax({
              url: "/rooms/" + id,
              type: "DELETE",
              contentType: "application/json",
            })
              .done(function () {
                showMessage("Deleted Successfully", "success");
                loadHalls();
              })
              .fail(function (jqXHR) {
                showMessage(
                  extractErrorMessage(jqXHR, "Unable to delete room / hall"),
                  "error"
                );
              });
          });
        });

        $("body").on("click", ".edit-hall-btn", function () {
          var id = $(this).val();
          $.get("/rooms/" + id)
            .done(function (data) {
              $("#editHallId").val(data.id);
              $("#editHallType").val(data.name);
              $("#editHallStatus").val(data.status);
              $("#editHallModal").modal("show");
            })
            .fail(function (jqXHR) {
              showMessage(
                extractErrorMessage(jqXHR, "Unable to fetch room / hall"),
                "error"
              );
            });
        });

        $("body").on("click", ".edit-category-btn", function () {
          var id = $(this).val();
          $.get("/menu-category/" + id)
            .done(function (data) {
              $("#editId").val(data.id);
              $("#editName").val(data.name);
              $("#editStatus").val(data.status);
              $("#editMenuCategory").modal("show");
            })
            .fail(function (jqXHR) {
              showMessage(
                extractErrorMessage(jqXHR, "Unable to fetch menu category"),
                "error"
              );
            });
        });

        $("body").on("click", ".delete-item-btn", function () {
          var id = $(this).val();
          showDeleteConfirmModal("Delete this item?", function () {
            $.ajax({
              url: "/menu-items/" + id,
              type: "DELETE",
              contentType: "application/json",
            })
              .done(function () {
                showMessage("Deleted Successfully", "success");
                loadItems();
                loadSubItems();
              })
              .fail(function (jqXHR) {
                showMessage(
                  extractErrorMessage(jqXHR, "Unable to delete item"),
                  "error"
                );
              });
          });
        });

        $("body").on("click", ".edit-item-btn", function () {
          var id = $(this).val();
          $.get("/menu-items/" + id)
            .done(function (data) {
              $("#editItemId").val(data.id);
              $("#editItemCategoryId").val(data.categoryId);
              $("#editItemName").val(data.name);
              $("#editItemDescription").val(data.description);
              $("#editItemPrice").val(data.price);
              $("#editItemStatus").val(data.status);
              $("#editItemModal").modal("show");
            })
            .fail(function (jqXHR) {
              showMessage(
                extractErrorMessage(jqXHR, "Unable to fetch item"),
                "error"
              );
            });
        });

        $("body").on("click", ".delete-subitem-btn", function () {
          var id = $(this).val();
          showDeleteConfirmModal("Delete this sub item?", function () {
            $.ajax({
              url: "/sub-items/" + id,
              type: "DELETE",
              contentType: "application/json",
            })
              .done(function () {
                showMessage("Deleted Successfully", "success");
                loadSubItems();
              })
              .fail(function (jqXHR) {
                showMessage(
                  extractErrorMessage(jqXHR, "Unable to delete sub item"),
                  "error"
                );
              });
          });
        });

        $("body").on("click", ".edit-subitem-btn", function () {
          var id = $(this).val();
          $.get("/sub-items/" + id)
            .done(function (data) {
              $("#editSubItemId").val(data.id);
              $("#editSubItemItemId").val(data.itemId);
              $("#editSubItemName").val(data.name);
              $("#editSubItemPrice").val(data.price);
              $("#editSubItemStatus").val(data.status);
              $("#editSubItemModal").modal("show");
            })
            .fail(function (jqXHR) {
              showMessage(
                extractErrorMessage(jqXHR, "Unable to fetch sub item"),
                "error"
              );
            });
        });

        $("body").on("click", ".delete-table-btn", function () {
          var id = $(this).val();
          showDeleteConfirmModal("Delete this table?", function () {
            $.ajax({
              url: "/tables/" + id,
              type: "DELETE",
              contentType: "application/json",
            })
              .done(function () {
                showMessage("Deleted Successfully", "success");
                loadTables();
              })
              .fail(function (jqXHR) {
                showMessage(
                  extractErrorMessage(jqXHR, "Unable to delete table"),
                  "error"
                );
              });
          });
        });

        $("body").on("click", ".edit-table-btn", function () {
          var id = $(this).val();
          $.get("/tables/" + id)
            .done(function (data) {
              $("#editTableId").val(data.id);
              $("#editTableName").val(data.tableName);
              $("#editTableStatus").val(data.status);
              $("#editTableHallId").val(data.hallId);
              $("#editTableModal").modal("show");
            })
            .fail(function (jqXHR) {
              showMessage(
                extractErrorMessage(jqXHR, "Unable to fetch table"),
                "error"
              );
            });
        });

        if (isAdminUser) {
          $("body").on("click", ".edit-subscription-amount-btn", function () {
            var id = $(this).data("id");
            var subscriptionPlan = $(this).data("plan");
            var amount = $(this).data("amount");

            if (!id) {
              showMessage("Invalid subscription amount selected", "error");
              return;
            }

            $("#editSubscriptionAmountId").val(id);
            $("#editSubscriptionAmountPlan").val(subscriptionPlan || "MONTHLY");
            $("#editSubscriptionAmountValue").val(amount || "");
            $("#editSubscriptionAmountModal").modal("show");
          });

          $("body").on("click", ".delete-subscription-amount-btn", function () {
            var id = $(this).data("id");
            if (!id) {
              showMessage("Invalid subscription amount selected", "error");
              return;
            }

            showDeleteConfirmModal("Delete this subscription amount?", function () {
              $.ajax({
                url: "/subscription-amounts/" + id,
                type: "DELETE",
                contentType: "application/json",
              })
                .done(function () {
                  showMessage("Subscription amount deleted successfully", "success");
                  loadSubscriptionAmounts();
                })
                .fail(function (jqXHR) {
                  showMessage(
                    extractErrorMessage(jqXHR, "Unable to delete subscription amount"),
                    "error"
                  );
                });
            });
          });

          $("body").on("click", ".edit-subscription-btn", function () {
            var id = $(this).data("id");
            var restaurantName = $(this).data("restaurant-name");
            var subscriptionPlan = $(this).data("plan");
            var subscriptionStartDate = $(this).data("start-date");

            if (!id) {
              showMessage("Invalid user selected", "error");
              return;
            }

            $("#editSubscriptionUserId").val(id);
            $("#editSubscriptionRestaurantName").val(restaurantName || "");
            $("#editSubscriptionPlan").val(subscriptionPlan || "MONTHLY");
            $("#editSubscriptionStartDate").val(subscriptionStartDate || "");
            $("#editSubscriptionModal").modal("show");
          });
        }
      });
    </script>
  </body>
</html>
