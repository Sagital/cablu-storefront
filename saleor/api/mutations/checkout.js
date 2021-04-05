import gql from 'graphql-tag'

const CheckoutFragment = gql`
  fragment CheckoutFragment on Checkout {
    id
    token
    lines {
      id
      quantity
      variant {
        id
        name
        pricing {
          price {
            net {
              amount
              currency
            }
          }
        }
        product {
          thumbnail {
            url
            alt
          }
        }
      }
    }
    quantity
  }
`

export const CHECKOUT_CREATE = gql`
  ${CheckoutFragment}

  mutation($email: String!, $variantId: ID!, $quantity: Int!) {
    checkoutCreate(
      input: { email: $email, lines: [{ quantity: $quantity, variantId: $variantId }] }
    ) {
      checkout {
        ...CheckoutFragment
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_LINES_ADD = gql`
  ${CheckoutFragment}

  mutation checkoutLinesAdd($checkoutId: ID!, $variantId: ID!, $quantity: Int!) {
    checkoutLinesAdd(
      checkoutId: $checkoutId
      lines: [{ quantity: $quantity, variantId: $variantId }]
    ) {
      checkout {
        ...CheckoutFragment
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_LINES_UPDATE = gql`
  ${CheckoutFragment}
  mutation checkoutLinesUpdate($checkoutId: ID!, $variantId: ID!, $quantity: Int!) {
    checkoutLinesUpdate(
      checkoutId: $checkoutId
      lines: [{ quantity: $quantity, variantId: $variantId }]
    ) {
      checkout {
        ...CheckoutFragment
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_LINES_DELETE = gql`
  ${CheckoutFragment}
  mutation checkoutLineDelete($checkoutId: ID!, $lineId: ID!) {
    checkoutLineDelete(checkoutId: $checkoutId, lineId: $lineId) {
      checkout {
        ...CheckoutFragment
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_EMAIL_UPDATE = gql`
  mutation($checkoutId: ID!, $email: String!) {
    checkoutEmailUpdate(checkoutId: $checkoutId, email: $email) {
      checkout {
        id
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_SHIPPING_ADDRESS_UPDATE = gql`
  mutation($checkoutId: ID!, $shippingAddress: AddressInput!) {
    checkoutShippingAddressUpdate(checkoutId: $checkoutId, shippingAddress: $shippingAddress) {
      checkout {
        id
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_PAYMENT_CREATE = gql`
  mutation checkoutPaymentCreate($checkoutId: ID!, $input: PaymentInput!) {
    checkoutPaymentCreate(checkoutId: $checkoutId, input: $input) {
      checkout {
        id
      }
      paymentErrors {
        code
        field
        message
      }
    }
  }
`

export const CHECKOUT_COMPLETE = gql`
  mutation($checkoutId: ID!) {
    checkoutComplete(checkoutId: $checkoutId) {
      order {
        id
        status
        paymentStatus
      }
      checkoutErrors {
        field
        message
      }
    }
  }
`

export const CHECKOUT_SHIPPING_METHOD_UPDATE = gql`
  mutation checkoutShippingMethodUpdate($checkoutId: ID!, $shippingMethodId: ID!) {
    checkoutShippingMethodUpdate(checkoutId: $checkoutId, shippingMethodId: $shippingMethodId) {
      checkout {
        id
        shippingPrice {
          net {
            amount
            currency
          }
          gross {
            amount
          }
        }
        totalPrice {
          net {
            amount
          }
          gross {
            amount
          }
        }
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`

export const CHECKOUT_BILLING_ADDRESS_UPDATE = gql`
  mutation($checkoutId: ID!, $billingAddress: AddressInput!) {
    checkoutBillingAddressUpdate(checkoutId: $checkoutId, billingAddress: $billingAddress) {
      checkout {
        id
      }
      checkoutErrors {
        field
        code
        message
      }
    }
  }
`
