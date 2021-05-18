import { IProduct } from '../../interfaces/product'

export interface CartItemOption {
  optionId: number
  optionTitle: string
  valueId: number
  valueTitle: string
}

export interface CartLine {
  id: string
  product: IProduct
  quantity: number
  total: number
}

export type CartTotalType = 'shipping' | 'tax'

export interface CartTotal {
  type: CartTotalType
  title: string
  price: number
}

export interface Cart {
  lines?: CartLine[]
  items: CartLine[]
  quantity: number
  total: number
}

export interface CartState extends Cart {
  lastItemId: number
}
