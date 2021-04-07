import { ILinkProps } from '../interfaces/menus/link-props';
import { ICategory, IShopCategory } from '../interfaces/category';

const url = {
    home: (): ILinkProps => ({
        href: '/',
    }),

    catalog: () => '/shop/catalog',

    cart: (): ILinkProps => ({
        href: '/shop/cart',
    }),

    checkout: (): ILinkProps => ({
        href: '/shop/checkout',
    }),

    category: (category: ICategory): ILinkProps => {
        if (category.type === 'shop') {
            return url.shopCategory(category);
        }
        if (category.type === 'blog') {
            return url.blogCategory();
        }

        throw Error('Undefined category type');
    },

    shopCategory: (category: IShopCategory): ILinkProps => ({
        href: '/shop/catalog/[slug]',
        as: `/shop/catalog/${category.slug}`,
    }),

    product: (product: { slug: string }): ILinkProps => ({
        href: '/shop/products/[slug]',
        as: `/shop/products/${product.slug}`,
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
};

export default url;
