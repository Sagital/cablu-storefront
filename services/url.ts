import { ILinkProps } from '../interfaces/menus/link-props'
import { IShopCategory } from '../interfaces/category'
import { ICategory } from '../types'

const url = {
  home: (): ILinkProps => ({
    href: '/',
  }),

  catalog: () => '/shop/catalog',

  cart: (): ILinkProps => ({
    href: '/cart',
  }),

  checkout: (): ILinkProps => ({
    href: '/checkout',
  }),

  category: (category: ICategory): ILinkProps => {
    return { href: '/s/[slug]', as: `/s/${category.slug}` }
    // throw Error('Undefined category type')
  },

  shopCategory: (category: IShopCategory): ILinkProps => ({
    href: '/shop/catalog/[slug]',
    as: `/shop/catalog/${category.slug}`,
  }),

  product: (product: { id: string }): ILinkProps => ({
    href: '/p/[id]',
    as: `/p/${product.id}`,
  }),

  wishlist: (): ILinkProps => ({
    href: '/shop/wishlist',
  }),

  blogCategory: (): ILinkProps => ({
    href: '/blog/category-classic',
  }),

  blogPost: (): ILinkProps => ({
    href: '/blog/post-classic',
  }),

  accountSignIn: (): ILinkProps => ({
    href: '/account/login',
  }),

  accountSignUp: (): ILinkProps => ({
    href: '/account/login',
  }),

  accountSignOut: (): ILinkProps => ({
    href: '/account/login',
  }),

  accountDashboard: (): ILinkProps => ({
    href: '/account/dashboard',
  }),

  accountProfile: (): ILinkProps => ({
    href: '/account/profile',
  }),

  accountOrders: (): ILinkProps => ({
    href: '/account/orders',
  }),

  accountOrder: (order: { id: number }): ILinkProps => ({
    href: '/account/orders/[orderId]',
    as: `/account/orders/${order.id}`,
  }),

  accountAddresses: (): ILinkProps => ({
    href: '/account/addresses',
    as: '/account/addresses',
  }),

  accountAddress: (address: { id: number }): ILinkProps => ({
    href: '/account/addresses/[addressId]',
    as: `/account/addresses/${address.id}`,
  }),

  accountPassword: (): ILinkProps => ({
    href: '/account/password',
    as: '/account/password',
  }),

  contacts: (): ILinkProps => ({
    href: '/site/contact-us',
  }),

  terms: (): ILinkProps => ({
    href: '/site/terms',
  }),
}

export default url
