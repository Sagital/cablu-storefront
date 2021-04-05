import client from '../apolloClient'
import gql from 'graphql-tag'
import { SHOP_QUERY } from './queries/shop'

const getShopConfiguration = async () => {
  const variables = {
    // this has to be configurable
    channel: 'default-channel',
  }

  try {
    const response = await client.query({
      query: gql`
        ${SHOP_QUERY}
      `,
      variables,
    })

    return response.data.shop
  } catch (e) {
    console.log('caught error')
    console.log(JSON.stringify(e.networkError))
  }
}

export { getShopConfiguration }
