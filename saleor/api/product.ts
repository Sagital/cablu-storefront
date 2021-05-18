import gql from 'graphql-tag'
import { PRODUCT_VARIANT_QUERY, PRODUCTS_QUERY, PRODUCTS_SEARCH_QUERY } from './queries/product'
import {
  OrderDirection,
  Product,
  ProductCountableConnection,
  ProductFilterInput,
  ProductOrder,
  ProductOrderField,
  ProductVariant,
} from '../graphql'
import client from '../apolloClient'
import { convertProduct, convertProductVariant } from '../converters'

export const getProductVariant = async (id: string) => {
  const variables = {
    id,
  }

  const response = await client.query<{ productVariant: ProductVariant }>({
    query: gql`
      ${PRODUCT_VARIANT_QUERY}
    `,
    variables,
  })

  return convertProductVariant(response.data.productVariant)
}

export const getProducts = async (
  categoryIds: string[],
  filters: { [key: string]: string[] },
  sort: string
) => {
  const productFilterInput: ProductFilterInput = {
    categories: categoryIds,
    attributes: [],
  }

  const sortBy: ProductOrder = { direction: OrderDirection.Asc, field: ProductOrderField.Type }

  Object.keys(filters).forEach(k => {
    productFilterInput.attributes?.push({
      slug: k,
      values: filters[k],
    })
  })
  const [field, direction] = sort.split('_')

  if (field && direction) {
    // @ts-ignore
    sortBy.field = field.toUpperCase()
    // @ts-ignore
    sortBy.direction = direction.toUpperCase()
  }

  const variables = {
    first: 100,
    after: '',
    filter: productFilterInput,
    sortBy,
  }

  const response = await client.query<{ products: ProductCountableConnection }>({
    query: gql`
      ${PRODUCTS_QUERY}
    `,
    variables,
  })

  return response.data.products.edges
    .filter(e => e.node.defaultVariant !== null)
    .map(e => convertProduct(e.node))
}

export const searchProducts = async ({
  categoryId,
  searchTerm,
  limit,
}: {
  categoryId?: string
  searchTerm: string
  limit: number
}) => {
  const productFilterInput: ProductFilterInput = {
    search: searchTerm,
  }

  if (categoryId) {
    productFilterInput.categories = [categoryId]
  }

  const variables = {
    first: limit,
    after: '',
    filter: productFilterInput,
  }

  console.log(variables)

  const response = await client.query<{ products: ProductCountableConnection }>({
    query: gql`
      ${PRODUCTS_SEARCH_QUERY}
    `,
    variables,
  })

  return response.data.products.edges
    .filter(e => e.node.defaultVariant !== null)
    .map(e => convertProduct(e.node))
}
