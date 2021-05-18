import { IShopCategory } from './category'
import { IBrand } from './brand'
import { IFilterableList, IPaginatedList } from './list'
import { IFilter } from '../types'

export interface IProductAttributeValue {
  slug: string
  name: string
}

export interface IProductAttribute {
  slug: string
  name: string
  values: IProductAttributeValue[]
  featured?: boolean
}

export interface Image {
  src: string
  alt: string
}

export interface IProduct {
  id: string
  isAvailable: boolean
  sku: string
  slug: string
  name: string
  description: string
  media: Image[]
  thumbnail: Image
  price: number
  attributes: IProductAttribute[]
  quantityAvailable: number
}

export type IProductsList = IPaginatedList<IProduct> & IFilterableList<IProduct, IFilter>
