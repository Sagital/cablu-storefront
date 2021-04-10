import gql from 'graphql-tag'

const productsQuery = gql`
  query Products($filter: ProductFilterInput, $first: Int, $after: String, $sortBy: ProductOrder) {
    products(filter: $filter, first: $first, after: $after, sortBy: $sortBy) {
      edges {
        node {
          id
          slug
          name
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
              }
              discount {
                net {
                  currency
                  amount
                }
              }
            }
          }
          images {
            id
            url
            alt
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

const productQuery = gql`
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

  query Product($id: ID) {
    product(id: $id) {
      id
      seoTitle
      seoDescription
      name
      description
      slug
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
      updatedAt
      media {
        url
        alt
        sortOrder
        oembedData
      }
      defaultVariant {
        id
        name
        sku
        pricing {
          price {
            net {
              amount
            }
            gross {
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
`

export { productQuery, productsQuery }
