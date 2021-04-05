import React, { useState, useEffect, useMemo } from 'react'

//import fetch from 'react-storefront/fetch'

import PropTypes from 'prop-types'
import get from 'lodash/get'
import SessionContext from './SessionContext'

const initialState = {
  signedIn: false,
  loading: true,
  cart: {
    items: [],
  },
}

/**
 * Fetches user session data from a specific URL and provides it to descendant components via `SessionContext`.
 *
 * User and session data such as the number of items in the cart, the user's name, and email should always be
 * fetched when the app mounts, not in `getInitialProps`, otherwise the SSR result would not be cacheable
 * since it would contain user-specific data.
 */
export default function SessionProvider({ url, children }) {
  const [session, setSession] = useState(initialState)

  const context = useMemo(() => {
    return {
      session,
      actions: {
        /**
         * Signs an existing user in
         * @param {String} email The user's email
         * @param {String} password The user's password
         */
        async signIn({ email, password }) {
          const response = await fetch('/api/signIn', {
            method: 'post',
            body: JSON.stringify({
              email,
              password,
            }),
          })
          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(get(result, 'error', 'An error occurred during sign in'))
          }
        },

        /**
         * Signs the user out
         */
        async signOut() {
          const response = await fetch('/api/signOut', { method: 'post' })
          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(get(result, 'error', 'An error occurred during sign out'))
          }
        },

        /**
         * Signs the user up for a new account
         * @param {Object} options
         * @param {String} firstName The user's first name
         * @param {String} lastName The user's last name
         * @param {String} email The user's email address
         * @param {String} password The user's password
         * @param {Object} others Additional data to submit to api/signUp
         */
        async signUp({ firstName, lastName, email, password, ...others }) {
          const response = await fetch('/api/signUp', {
            method: 'post',
            body: JSON.stringify({
              firstName,
              lastName,
              email,
              password,
              ...others,
            }),
          })

          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(get(result, 'error', 'An error occurred during sign up'))
          }
        },

        /**
         * Adds items to the cart
         * @param {Object} product Product data object
         * @param {Number} quantity The quantity to add to the cart
         * @param {Object} otherParams Additional data to submit to api/addToCart
         */
        async addToCart({ product, quantity, ...otherParams }) {
          const response = await fetch('/api/cart/add', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              product,
              quantity,
              ...otherParams,
            }),
          })

          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(
              get(
                result,
                'error',
                'An unknown error occurred while attempting to add the item to your cart.'
              )
            )
          }
        },

        /**
         * Updates the items in the cart. Use this function to update the quantity of a product
         * in the cart or remove a product from the cart.
         * @param {Object} item Cart item to be updated
         * @param {number} quantity Expected quantity value
         * @param {Object} otherParams Additional data to submit to api/cart/update
         */
        async updateCart({ item, quantity, ...otherParams }) {
          const response = await fetch('/api/cart/update', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ item, quantity, ...otherParams }),
          })

          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(
              get(result, 'error', 'An unknown error occurred while making changes to your cart.')
            )
          }
        },

        /**
         * Removes item in the cart.
         * @param {Object} item Cart item to be updated
         * @param {Object} otherParams Additional data to submit to /api/cart/remove
         */
        async removeCartItem({ item, ...otherParams }) {
          const response = await fetch('/api/cart/remove', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ item, ...otherParams }),
          })

          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, ...result })
          } else {
            throw new Error(
              get(result, 'error', 'An unknown error occurred while removing item from your cart.')
            )
          }
        },

        /**
         * Updates checkout
         * @param {Object} shippingAddress checkout shipping address
         * @param {Object} billingAddress checkout billing address
         * @param {string} shippingMethodId
         * @param {string} email
         * @param {string} checkoutId
         * @param {string} paymentMethodId
         */
        async updateCheckout({
          checkoutId,
          email,
          paymentMethodId,
          billingAddress,
          shippingAddress,
          shippingMethodId,
        }) {
          const response = await fetch('/api/checkout/update', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              billingAddress,
              email,
              shippingAddress,
              shippingMethodId,
              checkoutId,
            }),
          })

          const result = await response.json()

          if (response.ok) {
            setSession({ ...session, paymentMethodId, ...result })
          } else {
            throw new Error(
              get(result, 'error', 'An unknown error occurred while updating the checkout.')
            )
          }
        },

        /**
         * Updates checkout
         * @param {string} checkoutId
         * @param {number} totalPrice
         * @param {string} paymentMethodId
         */
        async completeCheckout({ checkoutId, totalPrice, paymentMethodId }) {
          const response = await fetch('/api/checkout/complete', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              checkoutId,
              totalPrice,
              paymentMethodId,
            }),
          })

          const result = await response.json()

          setSession({ ...session, cart: { items: [] }, itemsInCart: 0 })

          if (response.ok) {
            return result
          } else {
            throw new Error(
              get(result, 'error', 'An unknown error occurred while updating the checkout.')
            )
          }
        },
      },
    }
  }, [session])

  useEffect(() => {
    async function fetchSession() {
      const response = await fetch(url)
      const result = await response.json()
      setSession({ ...result, loading: false })
    }

    if (url) fetchSession()
  }, [url])

  return <SessionContext.Provider value={context}>{children}</SessionContext.Provider>
}

SessionProvider.propTypes = {
  /**
   * A URL to fetch when the app mounts which establishes a user session and returns user and cart data
   * to be made available via `react-storefront/session/SessionContext`.
   */
  url: PropTypes.string,
}
