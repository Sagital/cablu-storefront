import {
  ProductVariant,
  AttributeValue,
  Maybe,
  Product,
  Address,
  Checkout,
  CheckoutLine,
  PriceRangeInput,
  VariantPricingInfo,
  TaxedMoney,
} from './graphql'
import { IProduct, IProductAttributeValue } from '../interfaces/product'

export function convertProductVariant(variant: ProductVariant) {
  const result: IProduct = {
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
    quantityAvailable: 0,
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

export const convertCheckoutLine = ({ id, quantity, variant }: CheckoutLine) => {
  return {
    lineId: id,
    id: variant.id,
    name: variant.product.name,
    thumbnail: { src: variant.product.thumbnail?.url || '' },
    quantity,
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

export const convertCheckoutCart = (checkout: Checkout) => {
  const cart = {
    id: checkout.id,
    // @ts-ignore
    items: checkout.lines?.map(line => convertCheckoutLine(line)),
  }
  const itemsInCart = cart.items?.reduce((total, item) => {
    return total + item.quantity
  }, 0)

  return { cart, itemsInCart }
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

export const convertCheckout = (checkout: Checkout) => {
  const cart = {
    id: checkout.id,
    items: checkout.lines?.map(line => convertCheckoutLine(line as CheckoutLine)),
  }
  const itemsInCart = cart.items?.reduce((total, item) => {
    return total + item.quantity
  }, 0)

  let shippingAddress = null

  if (checkout.shippingAddress) {
    shippingAddress = convertCheckoutAddressToAddress(checkout.shippingAddress)
  }

  let email = null

  // we use dummy@example.com as a placeholder for email address
  if (checkout.email && checkout.email !== 'dummy@example.com') {
    email = checkout.email
  }

  let billingAddress = null

  if (checkout.billingAddress) {
    billingAddress = convertCheckoutAddressToAddress(checkout.billingAddress)
  }

  return { cart, itemsInCart, shippingAddress, billingAddress, email }
}
