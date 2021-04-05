import { ApolloClient, InMemoryCache } from '@apollo/client'

export default new ApolloClient({
  uri: 'https://api.cablu.io/graphql/',
  cache: new InMemoryCache(),
})
