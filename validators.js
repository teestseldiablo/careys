// Validation utilities
const validateEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
};

const validatePin = (pin) => {
  return typeof pin === 'string' && pin.length > 0;
};

const validateAddress = (street, city, state, zip) => {
  return (
    typeof street === 'string' && street.trim().length > 0 &&
    typeof city === 'string' && city.trim().length > 0 &&
    typeof state === 'string' && state.trim().length > 0 &&
    typeof zip === 'string' && zip.trim().length > 0
  );
};

const validateExpenses = (amount) => {
  const num = parseFloat(amount);
  return !isNaN(num) && num >= 0;
};

module.exports = {
  validateEmail,
  validatePin,
  validateAddress,
  validateExpenses
};
