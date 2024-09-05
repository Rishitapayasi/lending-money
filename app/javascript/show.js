document.addEventListener("DOMContentLoaded", function() {
  let modal = document.getElementById("loan-repay-modal");
  let payLoan = document.getElementById("pay-loan");
  let repayLoan = document.getElementById("repay-loan")
  payLoan.onclick = function() {
    event.preventDefault();
    modal.classList.remove("hidden");
  };

  document.getElementById("repay-loan").onclick = function() {
    modal.classList.add("hidden");
  };

  document.getElementById('cancel').onclick = ()=> {
    modal.classList.add("hidden");
  };
});
