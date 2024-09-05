document.addEventListener("DOMContentLoaded", function() {

  let modal = document.getElementById("loan-request-modal");
  let loanRequestButton = document.getElementById("loan-rq");
  let cancelButton = document.getElementById("cancel");
  let adjustButtons = document.querySelectorAll(".adjust-loan-button");
  let adjustModal = document.getElementById("adjust-loan-modal");
  let cancelAdjustButton = document.getElementById("cancel-adjust");
  let adjustLoanForm = document.getElementById("adjust-loan-form");
  let adjustLoanAmount = document.getElementById("adjust-loan-amount");
  let adjustLoanInterest = document.getElementById("adjust-loan-interest");

  console.log('Loan Request Modal:', modal);
  console.log('Loan Request Button:', loanRequestButton);
  console.log('Cancel Button:', cancelButton);
  console.log('Adjust Buttons:', adjustButtons);
  console.log('Adjust Modal:', adjustModal);
  console.log('Cancel Adjust Button:', cancelAdjustButton);
  console.log('Adjust Loan Form:', adjustLoanForm);
  console.log('Adjust Loan Amount:', adjustLoanAmount);
  console.log('Adjust Loan Interest:', adjustLoanInterest);


  if (loanRequestButton) {
    loanRequestButton.onclick = function(event) {
      event.preventDefault();
      if (modal) modal.classList.remove("hidden");
    };
  }

  if (cancelButton) {
    cancelButton.onclick = function() {
      if (modal) modal.classList.add("hidden");
    };
  }

  if (adjustModal && adjustButtons.length) {
    adjustButtons.forEach(button => {
      button.addEventListener("click", function(event) {
        event.preventDefault();
        let loanId = button.getAttribute("data-loan-id");
        let loanAmount = button.getAttribute("data-loan-amount");
        let loanInterest = button.getAttribute("data-loan-interest");

        if (adjustLoanForm) {
          adjustLoanForm.action = `/loan_requests/${loanId}/adjust`;
        }

        if (adjustLoanAmount) {
          adjustLoanAmount.value = loanAmount;
        }

        if (adjustLoanInterest) {
          adjustLoanInterest.value = loanInterest;
        }

        if (adjustModal) {
          adjustModal.classList.remove("hidden");
        }
      });
    });
  }

  if (cancelAdjustButton) {
    cancelAdjustButton.onclick = function() {
      if (adjustModal) adjustModal.classList.add("hidden");
    };
  }
});