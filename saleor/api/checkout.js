import gql from 'graphql-tag'
import client from '../apolloClient'
import {
  CHECKOUT_BILLING_ADDRESS_UPDATE,
  CHECKOUT_COMPLETE,
  CHECKOUT_CREATE,
  CHECKOUT_EMAIL_UPDATE,
  CHECKOUT_LINES_ADD,
  CHECKOUT_LINES_DELETE,
  CHECKOUT_LINES_UPDATE,
  CHECKOUT_PAYMENT_CREATE,
  CHECKOUT_SHIPPING_ADDRESS_UPDATE,
  CHECKOUT_SHIPPING_METHOD_UPDATE,
} from './mutations/checkout'
import { CHECKOUT_QUERY } from './queries/checkout'
const createCheckout = async (variantId, quantity) => {
  const variables = {
    variantId: variantId,
    quantity: quantity,
    email: '',
  }

  // TODO saleor needs a dummy email in order to create a guest checkout. Need to check if has to be different for each client
  variables.email = 'dummy@example.com'

  let response = null

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_CREATE}
      `,
      variables,
    })
  } catch (e) {
    console.log('ERROR')
    console.log(JSON.stringify(e))
    throw e
  }

  return response.data.checkoutCreate.checkout
}

const addCheckoutLine = async (checkoutId, variantId, quantity) => {
  const variables = {
    checkoutId,
    variantId,
    quantity,
  }

  console.log(variables)

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_ADD}
      `,
      variables,
    })

    // TODO handle errors, insufficient stock. etc
    console.log(JSON.stringify(response.data.checkoutLinesAdd.checkoutErrors))

    return response.data.checkoutLinesAdd.checkout
  } catch (e) {
    console.log(JSON.stringify(e.networkError))
  }
}

const getCheckout = async token => {
  const variables = {
    token: token,
  }

  const response = await client.query({
    query: gql`
      ${CHECKOUT_QUERY}
    `,
    variables,
  })

  return response.data.checkout
}

const updateCheckoutLine = async (checkoutId, variantId, quantity) => {
  const variables = {
    checkoutId,
    variantId,
    quantity,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_UPDATE}
      `,
      variables,
    })

    return response.data.checkoutLinesUpdate.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

const checkoutEmailUpdate = async (checkoutId, email) => {
  const variables = {
    checkoutId,
    email,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_EMAIL_UPDATE}
      `,
      variables,
    })

    // TODO error handling

    return response.data.checkoutEmailUpdate.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

const convertAddress = address => {
  return {
    firstName: address.firstName,
    lastName: address.lastName,
    phone: address.phone,
    streetAddress1: address.streetAddress,
    streetAddress2: address.streetAddress,
    countryArea: address.region,
    city: address.locality,
    country: 'RO',
  }
}

const checkoutShippingAddressUpdate = async (checkoutId, address) => {
  const shippingAddress = convertAddress(address)

  const variables = {
    checkoutId,
    shippingAddress,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_SHIPPING_ADDRESS_UPDATE}
      `,
      variables,
    })

    if (response.data.checkoutShippingAddressUpdate.checkoutErrors) {
      console.log(response.data.checkoutShippingAddressUpdate.checkoutErrors)
    }

    return response.data.checkoutShippingAddressUpdate.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

const checkoutShippingMethodUpdate = async (checkoutId, shippingMethodId) => {
  const variables = {
    checkoutId,
    shippingMethodId,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_SHIPPING_METHOD_UPDATE}
      `,
      variables,
    })

    if (response.data.checkoutShippingMethodUpdate.checkoutErrors) {
      console.log(response.data.checkoutShippingMethodUpdate.checkoutErrors)
    }

    return response.data.checkoutShippingMethodUpdate.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e))
  }
}

const checkoutBillingAddressUpdate = async (checkoutId, address) => {
  const billingAddress = convertAddress(address)

  const variables = {
    checkoutId,
    billingAddress,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_BILLING_ADDRESS_UPDATE}
      `,
      variables,
    })

    if (response.data.checkoutBillingAddressUpdate.checkoutErrors) {
      console.log(response.data.checkoutBillingAddressUpdate.checkoutErrors)
    }

    return response.data.checkoutBillingAddressUpdate.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

const checkoutPaymentCreate = async (checkoutId, paymentMethodId, totalPrice) => {
  const paymentInput = {
    gateway: paymentMethodId,
    amount: totalPrice,
    token: 'dummy',
  }

  const variables = {
    checkoutId,
    input: paymentInput,
  }

  console.log(variables)

  let checkoutPaymentCreate = null

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_PAYMENT_CREATE}
      `,
      variables,
    })

    checkoutPaymentCreate = response.data.checkoutPaymentCreate

    // TODO verify response.data.checkoutPaymentCreate.paymentErrors
  } catch (e) {
    console.log(JSON.stringify(e.networkError))
    throw e
  }

  console.log(JSON.stringify(checkoutPaymentCreate))

  if (checkoutPaymentCreate.paymentErrors.length) {
    throw Error(JSON.stringify(checkoutPaymentCreate.paymentErrors))
  }

  return checkoutPaymentCreate.checkout
}

const checkoutComplete = async checkoutId => {
  const variables = {
    checkoutId,
  }

  console.log(variables)

  let checkoutComplete = null

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_COMPLETE}
      `,
      variables,
    })

    // TODO verify response.data.checkoutComplete.checkoutErrors
    checkoutComplete = response.data.checkoutComplete
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
    throw Error(JSON.stringify(e.networkError))
  }

  console.log(JSON.stringify(checkoutComplete))

  if (checkoutComplete.checkoutErrors.length) {
    throw Error(JSON.stringify(checkoutComplete.checkoutErrors))
  }

  return checkoutComplete.order
}

const deleteCheckoutLine = async (checkoutId, lineId) => {
  const variables = {
    checkoutId,
    lineId,
  }

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_DELETE}
      `,
      variables,
    })

    // TODO what if the the quantity is exceeded

    return response.data.checkoutLineDelete.checkout
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

export {
  createCheckout,
  addCheckoutLine,
  updateCheckoutLine,
  checkoutPaymentCreate,
  checkoutComplete,
  checkoutShippingAddressUpdate,
  checkoutBillingAddressUpdate,
  checkoutShippingMethodUpdate,
  deleteCheckoutLine,
  getCheckout,
  checkoutEmailUpdate,
}
