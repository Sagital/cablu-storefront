export const validateAddress = address => {
  const errors = {}

  if (!address.firstName) {
    errors.firstName = 'Required'
  }

  if (!address.lastName) {
    errors.lastName = 'Required'
  }

  if (!address.phone) {
    errors.phone = 'Required'
  }

  if (!address.region) {
    errors.region = 'Required'
  }

  if (!address.locality) {
    errors.locality = 'Required'
  }

  if (!address.streetAddress) {
    errors.streetAddress = 'Required'
  }

  return errors
}
