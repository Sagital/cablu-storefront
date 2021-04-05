import gql from 'graphql-tag'

// const CHECKOUT_QUERY = gql`
//   query Checkout($token: UUID!) {
//     checkout(token: $token) {
//       id
//       token
//       email
//       lines {
//         id
//         quantity
//         variant {
//           id
//           name
//           sku
//           attributes {
//             attribute {
//               id
//               name
//             }
//             values {
//               id
//               name
//             }
//           }
//           product {
//             id
//             name
//             attributes {
//               attribute {
//                 id
//                 name
//               }
//               values {
//                 id
//                 name
//               }
//             }
//             thumbnail {
//               url
//             }
//           }
//           images {
//             id
//             url
//             sortOrder
//           }
//           pricing {
//             price {
//               net {
//                 amount
//               }
//             }
//           }
//         }
//       }
//       shippingPrice {
//         net {
//           amount
//           currency
//         }
//       }
//       shippingAddress {
//         id
//         firstName
//         lastName
//         companyName
//         streetAddress1
//         streetAddress2
//         city
//         cityArea
//         postalCode
//         country {
//           code
//           country
//         }
//         countryArea
//         phone
//       }
//       billingAddress {
//         id
//         firstName
//         lastName
//         companyName
//         streetAddress1
//         streetAddress2
//         city
//         cityArea
//         postalCode
//         country {
//           code
//           country
//         }
//         countryArea
//         phone
//       }
//       shippingMethod {
//         id
//         name
//         price {
//           amount
//           currency
//         }
//       }
//       quantity
//       totalPrice {
//         net {
//           amount
//         }
//         gross {
//           amount
//         }
//       }
//     }
//   }
// `

const PRODUCT_VARIANT_QUERY = gql`
  query ProductVariant($id: ID) {
    productVariant(id: $id) {
      id
      name
      sku
      pricing {
        price {
          net {
            amount
          }
        }
      }
      product {
        id
        name
        thumbnail {
          url
          alt
        }
        description
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
        media {
          id
          url
          alt
        }
      }
    }
  }
`

export { PRODUCT_VARIANT_QUERY }
