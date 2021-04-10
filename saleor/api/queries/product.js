import gql from 'graphql-tag'

const PRODUCTS_QUERY = gql`
  query Products($filter: ProductFilterInput, $first: Int, $after: String, $sortBy: ProductOrder) {
    products(filter: $filter, first: $first, after: $after, sortBy: $sortBy) {
      edges {
        node {
          id
          slug
          name
          media {
            url
            alt
          }
          thumbnail {
            url
            alt
          }
          slug
          defaultVariant {
            id
            name
            sku
            pricing {
              price {
                net {
                  currency
                  amount
                }
                gross {
                  currency
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
        }
      }
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
`

const PRODUCT_VARIANT_QUERY = gql`
  query ProductVariant($id: ID) {
    productVariant(id: $id) {
      id
      name
      sku
      quantityAvailable
      pricing {
        price {
          net {
            amount
          }
          gross {
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
            slug
            name
          }
          values {
            name
            slug
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

export { PRODUCT_VARIANT_QUERY, PRODUCTS_QUERY }
