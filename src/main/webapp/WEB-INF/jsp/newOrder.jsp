<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Table UI</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap -->
    <link rel="stylesheet" href="/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/css/bootstrap-icons.css" />

    <style>
      .tables-btn {
        width: 75px;
        height: 75px;
        margin: 12px; /* little extra for overflow */
        border-radius: 10px;
        border: 2px solid #7b2cbf;
        background: linear-gradient(145deg, #f3e8ff, #ffffff);

        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;

        font-size: 18px;
        font-weight: bold;
        cursor: pointer;

        position: relative; /* 🔥 important */
        transition: 0.3s;
      }

      .tables-btn:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 10px rgba(123, 44, 191, 0.3);
      }

      /* 🔥 PERFECT bottom-center placement */
      .icons {
        position: absolute;
        bottom: 0; /* stick to bottom */
        left: 50%;
        transform: translate(-50%, 50%); /* move half outside */

        display: flex;
        gap: 3px;
        font-size: 14px;

        background: #fff; /* cover border nicely */
        padding: 2px 6px;
        border-radius: 10px;
      }

      .icons i {
        cursor: pointer;
        padding: 2px;
      }

      .bi-eye {
        color: #007bff;
      }

      .bi-printer {
        color: #28a745;
      }

      .icons i:hover {
        background-color: #eee;
        border-radius: 4px;
      }
    </style>

    <script>
      function openTable(tableNo) {
        alert("Opening Table: " + tableNo);
      }

      function viewTable(event, tableNo) {
        event.stopPropagation();
        alert("Viewing Table: " + tableNo);
      }

      function printTable(event, tableNo) {
        event.stopPropagation();
        alert("Printing Bill: " + tableNo);
      }
    </script>
  </head>

  <body>
    <div class="container-fluid">
      <form>
        <!-- AC Tables -->
        <div class="panel panel-default">
          <div class="panel-heading"><b>AC Table</b></div>
          <div class="panel-body">
            <div class="form-group col-md-12 row">
              <button type="button" class="tables-btn" data-table="1">
                1
                <div class="icons">
                  <i class="bi bi-eye view-icon"></i>
                  <i class="bi bi-printer print-icon"></i>
                </div>
              </button>
            </div>
          </div>
        </div>

        <!-- NON-AC Tables -->
        <div class="panel panel-default">
          <div class="panel-heading"><b>NON - AC Table</b></div>
          <div class="panel-body">
            <div class="form-group col-md-12 row">
              <button type="button" class="table-btn" data-table="11">
                B1
                <div class="icons">
                  <i class="bi bi-eye view-icon"></i>
                  <i class="bi bi-printer print-icon"></i>
                </div>
              </button>
            </div>
          </div>
        </div>
      </form>
    </div>

    <script>
      alert();
    </script>
  </body>
</html>
