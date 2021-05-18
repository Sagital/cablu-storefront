import {
  ProductVariant,
  AttributeValue,
  Maybe,
  Product,
  Address,
  Checkout,
  CheckoutLine,
  TaxedMoney,
} from './graphql'
import { IProduct, IProductAttributeValue } from '../interfaces/product'
import { Cart, CartLine } from '../components/types'
import { ICheckout } from '../types'

export function convertProductVariant(variant: ProductVariant) {
  const result: IProduct = {
    isAvailable: variant.product.isAvailable || false,
    attributes: [],
    quantityAvailable: variant.quantityAvailable,
    media: [],
    slug: variant.product.slug,
    id: variant.id,
    sku: variant.sku,
    name: variant.product.name,
    price: variant.pricing?.price?.gross.amount || 0,
    description: variant.product.description,
    thumbnail: {
      // an array of thumbnails to display below the main image carousel
      src: variant.product.thumbnail?.url || '', // the thumbnail URL
      alt: variant.product.thumbnail?.alt || '', // alt text for the thumbnail
    },
  }

  result.attributes =
    variant.product.attributes?.map(selected => {
      return {
        name: selected.attribute.name || '',
        slug: selected.attribute.slug || '',
        values: selected.values.map(convertAttributeValue) || [],
      }
    }) || []

  result.media =
    variant.product.media?.map(m => {
      return {
        src: m.url,
        alt: m.alt,
      }
    }) || []

  return result
}

export function convertProduct(product: Product) {
  const result: IProduct = {
    isAvailable: product.isAvailable || false,
    quantityAvailable: product.defaultVariant?.quantityAvailable || 0,
    attributes: [],
    media: [],
    slug: product.slug,
    id: product.defaultVariant?.id || '',
    sku: product.defaultVariant?.sku || '',
    name: product.name,
    price: product.defaultVariant?.pricing?.price?.gross.amount || 0,
    description: product.description,
    thumbnail: {
      // an array of thumbnails to display below the main image carousel
      src: product.thumbnail?.url || '', // the thumbnail URL
      alt: product.thumbnail?.alt || '', // alt text for the thumbnail
    },
  }

  return result
}

const convertAttributeValue = (av: Maybe<AttributeValue>): IProductAttributeValue => {
  if (av === null) {
    return {
      name: '',
      slug: '',
    }
  }

  return {
    name: av.name || '',
    slug: av.slug || '',
  }
}

const convertCheckoutAddressToAddress = (checkoutAddress: Address) => {
  return {
    firstName: checkoutAddress.firstName,
    lastName: checkoutAddress.lastName,
    phone: checkoutAddress.phone?.replace(/^\+4/, '') || '',
    region: checkoutAddress.countryArea,
    locality: checkoutAddress.city,
    streetAddress: checkoutAddress.streetAddress1,
  }
}

export const convertShippingPrice = (checkoutShippingPrice: TaxedMoney) => {
  return {
    net: checkoutShippingPrice.net.amount,
    gross: checkoutShippingPrice.gross.amount,
  }
}

export const convertTotalPrice = (checkoutTotalPrice: TaxedMoney) => {
  return {
    net: checkoutTotalPrice.net.amount,
    gross: checkoutTotalPrice.gross.amount,
  }
}

export const extractCheckoutCart = (checkout: Checkout): Cart => {
  const cart = {
    id: checkout.id,
    items: checkout.lines?.map(line => convertCheckoutLineToCartItem(line as CheckoutLine)) || [],
    quantity: 0,
    total: 0,
  }

  cart.quantity =
    cart.items?.reduce((total, item) => {
      return total + item.quantity
    }, 0) || 0

  cart.total =
    cart.items?.reduce((total, item) => {
      return total + item.product.price * item.quantity
    }, 0) || 0

  return cart
}

export const convertCheckoutLineToCartItem = ({
  id,
  quantity,
  variant,
}: CheckoutLine): CartLine => {
  return {
    id: id,
    product: convertProductVariant(variant),
    quantity,
    total: quantity * (variant.pricing?.price?.gross.amount || 0),
  }
}

export const convertCheckout = (checkout: Checkout): ICheckout => {
  const cart = extractCheckoutCart(checkout)

  let shippingAddress

  if (checkout.shippingAddress) {
    shippingAddress = convertCheckoutAddressToAddress(checkout.shippingAddress)
  }

  let email

  // we use dummy@example.com as a placeholder for email address
  if (checkout.email && checkout.email !== 'dummy@example.com') {
    email = checkout.email
  }

  let billingAddress

  if (checkout.billingAddress) {
    billingAddress = convertCheckoutAddressToAddress(checkout.billingAddress)
  }

  let shippingPrice

  if (checkout.shippingPrice) {
    shippingPrice = convertShippingPrice(checkout.shippingPrice)
  }

  let totalPrice
  if (checkout.totalPrice) {
    totalPrice = convertTotalPrice(checkout.totalPrice)
  }

  return {
    id: checkout.id,
    token: checkout.token,
    cart,
    shippingAddress,
    billingAddress,
    email,
    shippingPrice,
    totalPrice,
    shippingMethodId: checkout.shippingMethod?.id,
  }
}
