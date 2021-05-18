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
import { convertCheckout, extractCheckoutCart } from '../converters'
import { AddressInput, CheckoutError, CountryCode } from '../graphql'
import { IAddress, ICheckout } from '../../types'
import { Cart } from '../../components/types'

const createCheckout = async (variantId: string, quantity: number): Promise<ICheckout> => {
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
    throw e
  }

  if (response.data.checkoutCreate.checkoutErrors.length) {
    handleErrors(response.data.checkoutCreate.checkoutErrors)
  }

  return convertCheckout(response.data.checkoutCreate.checkout)
}

const addCheckoutLine = async (
  checkoutId: string,
  variantId: string,
  quantity: number
): Promise<ICheckout> => {
  const variables = {
    checkoutId,
    variantId,
    quantity,
  }

  let response

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_ADD}
      `,
      variables,
    })
  } catch (e) {
    // TODO test this
    throw e
  }

  if (response.data.checkoutLinesAdd.checkoutErrors.length) {
    handleErrors(response.data.checkoutLinesAdd.checkoutErrors)
  }

  return convertCheckout(response.data.checkoutLinesAdd.checkout)
}

const getCheckout = async (token: string): Promise<ICheckout> => {
  const variables = {
    token: token,
  }

  const response = await client.query({
    query: gql`
      ${CHECKOUT_QUERY}
    `,
    variables,
  })

  const checkout = response.data.checkout

  return convertCheckout(checkout)
}

const updateCheckoutLine = async (
  checkoutId: string,
  variantId: string,
  quantity: number
): Promise<Cart> => {
  const variables = {
    checkoutId,
    variantId,
    quantity,
  }

  let response

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_UPDATE}
      `,
      variables,
    })
  } catch (e) {
    throw e
  }

  if (response.data.checkoutLinesUpdate.checkoutErrors.length) {
    throw Error(getErrors(response.data.checkoutLinesUpdate.checkoutErrors))
  } else {
    return extractCheckoutCart(response.data.checkoutLinesUpdate.checkout)
  }
}

const checkoutEmailUpdate = async (checkoutId: string, email: string) => {
  const variables = {
    checkoutId,
    email,
  }

  let response

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_EMAIL_UPDATE}
      `,
      variables,
    })
  } catch (e) {
    console.log(e)
    throw e
  }

  console.log(response.data.checkoutEmailUpdate.checkoutErrors)

  if (response.data.checkoutEmailUpdate.checkoutErrors.length) {
    handleErrors(response.data.checkoutEmailUpdate.checkoutErrors)
  } else {
    return response.data.checkoutEmailUpdate.checkout
  }
}

const convertIAddressToAddressInput = (address: IAddress): AddressInput => {
  return {
    firstName: address.firstName,
    lastName: address.lastName,
    phone: address.phone,
    streetAddress1: address.streetAddress,
    streetAddress2: address.streetAddress,
    countryArea: address.region,
    city: address.locality,
    country: CountryCode.Ro,
  }
}

const checkoutShippingAddressUpdate = async (checkoutId: string, address: IAddress) => {
  const shippingAddress = convertIAddressToAddressInput(address)

  const variables = {
    checkoutId,
    shippingAddress,
  }

  let response

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_SHIPPING_ADDRESS_UPDATE}
      `,
      variables,
    })
  } catch (e) {
    throw e
  }

  if (response.data.checkoutShippingAddressUpdate.checkoutErrors.length) {
    handleErrors(response.data.checkoutShippingAddressUpdate.checkoutErrors)
  } else {
    return response.data.checkoutShippingAddressUpdate.checkout
  }
}

const checkoutShippingMethodUpdate = async (checkoutId: string, shippingMethodId: string) => {
  const variables = {
    checkoutId,
    shippingMethodId,
  }

  console.log(variables)
  let response

  console.log('updating checkout shipping method')

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_SHIPPING_METHOD_UPDATE}
      `,
      variables,
    })
  } catch (e) {
    console.log(e)
    throw e
  }

  console.log(response.data.checkoutShippingMethodUpdate)

  if (response.data.checkoutShippingMethodUpdate.checkoutErrors.length) {
    handleErrors(response.data.checkoutShippingMethodUpdate.checkoutErrors)
  }

  return response.data.checkoutShippingMethodUpdate.checkout
}

const checkoutBillingAddressUpdate = async (checkoutId: string, address: IAddress) => {
  const billingAddress = convertIAddressToAddressInput(address)

  if (address.company) {
    billingAddress.companyName = address.company
    billingAddress.cityArea = address.taxCode
  }

  const variables = {
    checkoutId,
    billingAddress,
  }

  let response

  try {
    response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_BILLING_ADDRESS_UPDATE}
      `,
      variables,
    })
  } catch (e) {
    console.log(e)
    throw e
  }

  if (response.data.checkoutBillingAddressUpdate.checkoutErrors.length) {
    handleErrors(response.data.checkoutBillingAddressUpdate.checkoutErrors)
  }

  return response.data.checkoutBillingAddressUpdate.checkout
}

// const checkoutPaymentCreate = async (checkoutId, paymentMethodId, totalPrice) => {
//   const paymentInput = {
//     gateway: paymentMethodId,
//     amount: totalPrice,
//     token: 'dummy',
//   }
//
//   const variables = {
//     checkoutId,
//     input: paymentInput,
//   }
//
//   let checkoutPaymentCreate = null
//
//   try {
//     const response = await client.mutate({
//       mutation: gql`
//         ${CHECKOUT_PAYMENT_CREATE}
//       `,
//       variables,
//     })
//
//     checkoutPaymentCreate = response.data.checkoutPaymentCreate
//
//     // TODO verify response.data.checkoutPaymentCreate.paymentErrors
//   } catch (e) {
//     console.log(JSON.stringify(e.networkError))
//     throw e
//   }
//
//   console.log(JSON.stringify(checkoutPaymentCreate))
//
//   if (checkoutPaymentCreate.paymentErrors.length) {
//     throw Error(JSON.stringify(checkoutPaymentCreate.paymentErrors))
//   }
//
//   return checkoutPaymentCreate.checkout
// }

const checkoutComplete = async (checkoutId: string) => {
  const variables = {
    checkoutId,
  }

  let checkoutComplete = null

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_COMPLETE}
      `,
      variables,
    })

    checkoutComplete = response.data.checkoutComplete
  } catch (e) {
    console.log(e)
    throw e
  }

  console.log('checkout errors')
  console.log(checkoutComplete.checkoutErrors)

  if (checkoutComplete.checkoutErrors.length) {
    handleErrors(checkoutComplete.checkoutErrors)
  }

  return checkoutComplete.order
}

const deleteCheckoutLine = async (checkoutId: string, lineId: string) => {
  const variables = {
    checkoutId,
    lineId,
  }

  let checkoutLineDelete

  try {
    const response = await client.mutate({
      mutation: gql`
        ${CHECKOUT_LINES_DELETE}
      `,
      variables,
    })

    checkoutLineDelete = response.data.checkoutLineDelete
  } catch (e) {
    throw e
  }

  if (checkoutLineDelete.checkoutErrors.length) {
    handleErrors(checkoutLineDelete.checkoutErrors)
  }

  return checkoutLineDelete.checkout
}

const getErrors = (errors: CheckoutError[]): string => {
  return errors.map(e => e.code).join(',')
}

const handleErrors = (errors: CheckoutError[]): never => {
  const errorCodes = errors.map(e => e.code)
  console.log(errorCodes)
  throw Error(errorCodes.join(','))
}

export {
  createCheckout,
  addCheckoutLine,
  updateCheckoutLine,
  checkoutComplete,
  checkoutShippingAddressUpdate,
  checkoutBillingAddressUpdate,
  checkoutShippingMethodUpdate,
  deleteCheckoutLine,
  getCheckout,
  checkoutEmailUpdate,
}
