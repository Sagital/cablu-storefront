import { Cart } from '../components/types'

export interface FilterValue {
  id: string
  slug: string
  name: string
  count?: number
}

export type CategoryWithDepth = ICategory & { depth: number }

export interface IPayment {
  key: string
  title: string
  description: string
}

export interface ICheckout {
  id: string
  token: string
  cart: Cart
  billingAddress?: IAddress
  shippingAddress?: IAddress
  email?: string
  shippingMethodId?: string
  shippingPrice?: ITaxedMoney
  totalPrice?: ITaxedMoney
}

export interface IOrder {
  id: string
  clientId: string
  cart: Cart
  billingAddress?: IAddress
  shippingAddress?: IAddress
  email?: string
  shippingMethodId?: string
  shippingPrice?: ITaxedMoney
  totalPrice?: ITaxedMoney
}

export interface IFilter {
  id: string
  type: string
  name: string
  slug: string
  values: FilterValue[]
}

export interface ITaxedMoney {
  net: number
  gross: number
}

export class AppError {
  public readonly statusCode: number

  constructor(statusCode = 400) {
    this.statusCode = statusCode
  }
}

export interface IAddress {
  firstName: string
  lastName: string
  phone: string
  region: string
  locality: string
  streetAddress: string
  company?: string
  taxCode?: string
}

export type GetSuggestionsOptions = {
  limit?: number
  searchTerm: string
  categoryId?: string
}

export interface ICategory {
  id: string
  name: string
  slug: string
  children?: ICategory[]
}
