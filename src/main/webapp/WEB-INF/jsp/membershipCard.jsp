<!DOCTYPE html>
<html>
  <head>
    <title>Membership Card</title>
    <link href="/css/bootstrap5.min.css" rel="stylesheet" />

    <style>
      .membership-card {
        max-width: 380px;
        margin: auto;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border: 2px solid #9ad4ff; /* light blue border */
        background: #ffffff;
      }

      .card-header-custom {
        background: linear-gradient(
          135deg,
          #b3e5fc,
          #e1f5fe
        ); /* soft light blue */
        color: #054c7a;
        padding: 18px;
        font-size: 22px;
        font-weight: bold;
        text-align: center;
        border-bottom: 1px solid #90caf9;
      }

      .card-body {
        padding: 22px;
      }

      .card-body p {
        font-size: 16px;
        margin-bottom: 10px;
      }

      .label {
        font-weight: bold;
        color: #555;
      }

      .value {
        color: #0277bd; /* blue text */
        font-weight: 600;
      }

      .footer-line {
        height: 4px;
        background: linear-gradient(90deg, #b3e5fc, #81d4fa);
      }
    </style>
  </head>

  <body class="bg-light py-4">
    <div class="membership-card">
      <div class="card-header-custom">MEMBER CARD</div>

      <div class="card-body">
        <p>
          <span class="label">Member Type:</span>
          <span class="value">Owner</span>
        </p>

        <p>
          <span class="label">Member Name:</span>
          <span class="value">Surada Lokudasu</span>
        </p>

        <p>
          <span class="label">Member ID:</span>
          <span class="value">1</span>
        </p>

        <p>
          <span class="label">Mobile:</span>
          <span class="value">966696622</span>
        </p>

        <p>
          <span class="label">Membership Amount:</span>
          <span class="value">3000</span>
        </p>
      </div>

      <div class="footer-line"></div>
    </div>

    <script>
      function printPage() {
        const btn = document.getElementById("printBtn");
        btn.style.display = "none";

        window.print(); // Trigger print dialog
        btn.style.display = "inline-block";
      }
    </script>

    <button class="btn btn-primary" id="printBtn" onclick="printPage()">
      Print Receipt
    </button>
  </body>
</html>
