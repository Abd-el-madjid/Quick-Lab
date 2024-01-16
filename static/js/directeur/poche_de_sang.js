function toggleForm() {
                var form = document.getElementById("form_donat");
                form.classList.toggle("none");

             
}
            





function donat_info(event){
    const row = event.target.closest('.table-row_container');


    const blood_type = row.querySelector('.blood_type').textContent.trim().replace(/\s+/g, '');
    const blood_type_form = document.querySelector('.blood_type_form');
   
    blood_type_form.textContent = blood_type;
    const blood_type_input = document.querySelector('input[name="blood_type_input"]');

    blood_type_input.value = blood_type;

    const blood_bag = row.querySelector('.blood_bag').textContent.trim().replace(/\s+/g, '');
    const blood_bag_form = document.querySelector('input[name="blood_bag"]');
     const blood_bag_form1 = document.querySelector('input[name="blood_bag1"]');
    



    blood_bag_form.value = blood_bag;

    blood_bag_form1.value=blood_bag;
  
}
  



window.onload = function() {
  // Get the blood bag input element
  const bloodBagInput = document.querySelector('input[name="blood_bag"]');
  const bloodBag1Input = document.querySelector('input[name="blood_bag1"]');
  const form = document.querySelector('form');

  // Function to handle input change
  function handleInputChange() {
    const inputValue = parseInt(bloodBagInput.value);
    const maxBloodBagValue = parseInt(bloodBag1Input.value);

    // Check if the input value is greater than the maximum
    if (inputValue > maxBloodBagValue) {
      // Add CSS styling to the input element
      bloodBagInput.style.border = '2px solid red';

      // Create the error div and error message
      const errorDiv = document.createElement('div');
      errorDiv.classList.add('input-error');
      const errorMessage = document.createElement('p');
      errorMessage.textContent = 'The entered value is invalid. You do not have this number of bags.';

      // Append the error message to the error div
      errorDiv.appendChild(errorMessage);

      // Insert the error div after the blood bag input element
      bloodBagInput.parentNode.insertBefore(errorDiv, bloodBagInput.nextSibling);

      // Prevent form submission
      form.addEventListener('submit', preventSubmit);
    } else {
      // If the input value is valid, remove the CSS styling and error message
      bloodBagInput.style.border = '';
      const errorDiv = document.querySelector('.input-error');
      if (errorDiv) {
        errorDiv.remove();
      }

      // Allow form submission
      form.removeEventListener('submit', preventSubmit);
    }
  }

  // Function to prevent form submission
  function preventSubmit(event) {
    event.preventDefault();
  }

  // Add event listener for input change
  bloodBagInput.addEventListener('input', handleInputChange);
};
