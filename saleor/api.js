import { ApolloClient, InMemoryCache } from '@apollo/client'
import gql from 'graphql-tag'

import { PRODUCT_VARIANT_QUERY } from './queries'

const client = new ApolloClient({
  uri: 'https://api.cablu.io/graphql/',
  cache: new InMemoryCache(),
})

const getProductVariant = async id => {
  const variables = {
    id,
  }

  const response = await client.query({
    query: gql`
      ${PRODUCT_VARIANT_QUERY}
    `,
    variables,
    // temporary, seems like bug in apollo:
    // @link: https://github.com/apollographql/apollo-client/issues/3234
    fetchPolicy: 'no-cache',
  })

  return response.data.productVariant
}

export { getProductVariant }
