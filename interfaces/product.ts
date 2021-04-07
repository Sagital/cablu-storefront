import { IFilter } from './filter'

import { IShopCategory } from './category'
import { IBrand } from './brand'
import { IFilterableList, IPaginatedList } from './list'

export interface IProductAttributeValue {
  slug: string
  name: string
}

export interface IProductAttribute {
  slug: string
  name: string
  values: IProductAttributeValue[]
  featured: boolean
}

export interface Image {
  src: string
  alt: string
}

export interface IProduct {
  id: number
  url: string
  slug: string
  name: string
  images: string[]
  media: {
    full: Image[]
    thumbnails: Image[]
  }
  price: number
  compareAtPrice: number | null
  brand: IBrand | null
  badges: string[]
  categories: IShopCategory[]
  reviews: number
  rating: number
  attributes: IProductAttribute[]
  availability: string
}

export type IProductsList = IPaginatedList<IProduct> & IFilterableList<IProduct, IFilter>
