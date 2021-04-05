import gql from 'graphql-tag'

const DefaultProductVariantFragment = gql`
  fragment DefaultProductVariantFragment on ProductVariant {
    id
    name
    sku
    attributes {
      attribute {
        id
        name
      }
      values {
        id
        name
      }
    }
    images {
      id
      url
      sortOrder
    }
    pricing {
      price {
        net {
          amount
        }
      }
      discount {
        net {
          currency
          amount
        }
      }
    }
  }
`

export const checkoutCreateMutation = gql`
  ${DefaultProductVariantFragment}

  mutation($email: String!, $variantId: ID!, $quantity: Int!) {
    checkoutCreate(
      input: { email: $email, lines: [{ quantity: $quantity, variantId: $variantId }] }
    ) {
      created
      checkout {
        id
        token
        lines {
          id
          quantity
          variant {
            ...DefaultProductVariantFragment
          }
        }
        shippingPrice {
          net {
            amount
            currency
          }
        }
        quantity
        totalPrice {
          net {
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

export const checkoutLineAddMutation = gql`
  ${DefaultProductVariantFragment}

  mutation checkoutLinesAdd($checkoutId: ID!, $variantId: ID!, $quantity: Int!) {
    checkoutLinesAdd(
      checkoutId: $checkoutId
      lines: [{ quantity: $quantity, variantId: $variantId }]
    ) {
      checkout {
        id
        token
        email
        lines {
          id
          quantity
          variant {
            ...DefaultProductVariantFragment
            product {
              id
              id
              name
              thumbnail {
                url
                alt
              }
              attributes {
                attribute {
                  name
                }
                values {
                  name
                }
              }
              images {
                id
                url
                alt
              }
            }
          }
        }
        shippingPrice {
          net {
            amount
            currency
          }
        }
        quantity
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
