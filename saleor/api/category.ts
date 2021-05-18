import gql from 'graphql-tag'
import { CATEGORIES_QUERY } from './queries/category'
import { CategoryCountableConnection } from '../graphql'
import client from '../apolloClient'
import { ICategory } from '../../types'

export const getCategories = async (): Promise<ICategory[]> => {
  const response = await client.query<{ categories: CategoryCountableConnection }>({
    query: gql`
      ${CATEGORIES_QUERY}
    `,
  })

  return response.data.categories.edges.map(edge => {
    const { id, name, slug } = edge.node

    return { id, name, slug }
  })
}
