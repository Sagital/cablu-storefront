import gql from 'graphql-tag'

export const SHOP_QUERY = gql`
  query Shop($channel: String!) {
    shop {
      availableShippingMethods(channel: $channel) {
        id
        name
        price {
          amount
        }
      }
      availablePaymentGateways {
        id
        name
      }
    }
  }
`
