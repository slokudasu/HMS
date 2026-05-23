<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${memberName}_${month}_${year}</title>

    <!-- Bootstrap CSS -->
    <link href="/css/bootstrap5.min.css" rel="stylesheet" />

    <style>
      body {
        background-color: #f8f9fa;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }
      .receipt {
        background: white;
        border-radius: 10px;
        padding: 30px;
        max-width: 700px;
        margin: 50px auto;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .receipt-header {
        text-align: center;
        border-bottom: 2px solid #0d6efd;
        padding-bottom: 15px;
        margin-bottom: 25px;
      }
      .receipt-header h5 {
        color: #db7524;
      }
      .receipt-header h4 {
        color: #09a5e8;
      }
      .table th {
        background-color: #0d6efd;
        color: white;
      }
      .total {
        font-size: 1.2rem;
        font-weight: bold;
      }
      .footer {
        text-align: center;
        margin-top: 20px;
        font-size: 0.9rem;
        color: #777;
      }
    </style>
  </head>

  <body>
    <div class="receipt">
      <div class="receipt-header">
        <h4>Gayatri Associations (Reg No: 443/2021)</h4>
        <h5>Payment Receipt</h5>
        <p>Member Name: <strong>${memberName}</strong></p>
        <!--<p>Payment Date: <strong>${date}</strong></p> -->
        <p>Receipt No: <strong>${id}</strong></p>
      </div>

      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Description</th>
            <th>Year</th>
            <th>Month</th>
            <th>Amount</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Monthly Maintenance</td>
            <td>${year}</td>
            <td>${month}</td>
            <td>${amount}</td>
            <td>Paid</td>
          </tr>
        </tbody>
      </table>

      <div class="footer">
        <p><b>Thank you for your payment!</b></p>

        <button
          class="btn btn-primary mt-3"
          id="printBtn"
          onclick="printPage()"
        >
          Print Receipt
        </button>
      </div>
    </div>

    <script>
      function printPage() {
        const btn = document.getElementById("printBtn");
        btn.style.display = "none";

        window.print(); // Trigger print dialog
        btn.style.display = "inline-block";
      }
    </script>

    <!-- Bootstrap JS -->
    <script src="/js/bootstrap5.bundle.min.js"></script>
  </body>
</html>
