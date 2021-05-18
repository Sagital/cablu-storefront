// react
import React, { Fragment, useCallback, useContext, useState } from 'react'

// third-party
import classNames from 'classnames'
import Head from 'next/head'
import { CartLine } from '../components/types'
import AsyncAction from '../components/shared/AsyncAction'
import AppLink from '../components/shared/AppLink'
import CurrencyFormat from '../components/shared/CurrencyFormat'
import InputNumber from '../components/shared/InputNumber'
import url from '../services/url'
import PageHeader from '../components/shared/PageHeader'
import SessionContext from '../context/SessionContext'
import BlockLoader from '../components/blocks/BlockLoader'
import { toast } from 'react-toastify'
// application
import Cross12Svg from '../svg/cross-12.svg'
import Quickview16Svg from '../svg/quickview-16.svg'
import debounce from 'lodash.debounce'

export interface Quantity {
  itemId: string
  value: string | number
}

function CartPage() {
  const [quantities, setQuantities] = useState<Quantity[]>([])
  const { session, actions } = useContext(SessionContext)
  const [loading, setLoading] = useState(false)

  const cart = session.cart

  const cartRemoveItem = (itemId: string) => {
    return actions.removeCartItem({ id: cart.id, lineId: itemId })
  }

  const getProductQuantityFromCart = (productId: string): number => {
    return cart.items.find((i: CartLine) => i.product.id === productId).quantity
  }

  const getItemQuantity = (item: CartLine) => {
    const quantity = quantities.find(x => x.itemId === item.id)

    return quantity ? quantity.value : item.quantity
  }

  const debouncedSave = useCallback(
    debounce((item: CartLine, quantity) => {
      setLoading(true)
      actions
        .updateCart({ id: cart.id, item: item.product, quantity })
        .then(() => setLoading(false))
        .catch((e: Error) => {
          setLoading(false)
          setQuantity(item, getProductQuantityFromCart(item.product.id))

          toast.error(e.message, {
            position: 'top-right',
            autoClose: 5000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
          })
        })
    }, 500),
    [cart]
  )

  const setQuantity = (item: CartLine, quantity: number): void => {
    setQuantities(prevState => {
      const index = prevState.findIndex(x => x.itemId === item.id)

      if (index === -1) {
        return [
          ...prevState,
          {
            itemId: item.id,
            value: quantity,
          },
        ]
      }

      return [
        ...prevState.slice(0, index),
        {
          ...prevState[index],
          value: quantity,
        },
        ...prevState.slice(index + 1),
      ]
    })
  }

  const handleChangeQuantity = (item: CartLine, quantity: number) => {
    setQuantity(item, quantity)

    if (quantity) {
      debouncedSave(item, quantity)
    }
  }

  if (session.loading) {
    return <BlockLoader />
  }

  const breadcrumb = [
    { title: 'Home', url: '' },
    { title: 'Shopping Cart', url: '' },
  ]

  let content

  if (cart.quantity) {
    const cartItems = cart.items.map((item: CartLine) => {
      let image

      if (item.product.thumbnail) {
        image = (
          <div className="product-image">
            <AppLink href={url.product(item.product)} className="product-image__body">
              <img className="product-image__img" src={item.product.thumbnail.src} alt="" />
            </AppLink>
          </div>
        )
      }

      const removeButton = (
        <AsyncAction
          action={() => cartRemoveItem(item.id)}
          render={({ run, loading }) => {
            const classes = classNames('btn btn-light btn-sm btn-svg-icon', {
              'btn-loading': loading,
            })

            return (
              <button type="button" onClick={run} className={classes}>
                <Cross12Svg />
              </button>
            )
          }}
        />
      )

      return (
        <tr key={item.id} className="cart-table__row">
          <td className="cart-table__column cart-table__column--image">{image}</td>
          <td className="cart-table__column cart-table__column--product">
            <AppLink href={url.product(item.product)} className="cart-table__product-name">
              {item.product.name}
            </AppLink>
          </td>
          <td className="cart-table__column cart-table__column--price" data-title="Price">
            <CurrencyFormat value={item.product.price} />
          </td>
          <td className="cart-table__column cart-table__column--quantity" data-title="Quantity">
            <div style={{ display: 'flex' }}>
              <div style={{ minWidth: '40px' }}>
                {loading && (
                  <button type="button" className={`btn btn-light btn-loading btn-md btn-svg-icon`}>
                    <Quickview16Svg />
                  </button>
                )}
              </div>
              <div>
                <InputNumber
                  onChange={quantity => handleChangeQuantity(item, +quantity)}
                  value={getItemQuantity(item)}
                  min={1}
                  max={50}
                />
              </div>
            </div>
          </td>

          <td className="cart-table__column cart-table__column--total" data-title="Total">
            <CurrencyFormat value={item.total} />
          </td>

          <td className="cart-table__column cart-table__column--remove">{removeButton}</td>
        </tr>
      )
    })

    content = (
      <div className="cart block">
        <div className="container">
          <table className="cart__table cart-table">
            <thead className="cart-table__head">
              <tr className="cart-table__row">
                <th className="cart-table__column cart-table__column--image">Image</th>
                <th className="cart-table__column cart-table__column--product">Product</th>
                <th className="cart-table__column cart-table__column--price">Price</th>
                <th className="cart-table__column cart-table__column--quantity">Quantity</th>
                <th className="cart-table__column cart-table__column--total">Total</th>
                <th className="cart-table__column cart-table__column--remove" aria-label="Remove" />
              </tr>
            </thead>
            <tbody className="cart-table__body">{cartItems}</tbody>

            <tfoot className="cart-table__foot">
              <tr className="cart-table__row">
                <th className="" />
                <th className="cart-table__column" />
                <th className="cart-table__column" />
                <th className="cart-table__column" />
                <th
                  className="cart-table__column cart-table__column--cart-total"
                  data-title="Cart Total"
                >
                  <CurrencyFormat value={cart.total} />
                </th>
                <th className="cart-table__column--remove" aria-label="Remove" />
              </tr>
            </tfoot>
          </table>
          <div className="cart__actions">
            <div>
              <AppLink href="/" className="btn btn-light btn-block ">
                Continue Shopping
              </AppLink>
            </div>
            <div>
              <AppLink
                href={url.checkout()}
                className="btn btn-primary btn-block cart__checkout-button "
              >
                Proceed to checkout
              </AppLink>
            </div>
          </div>
        </div>
      </div>
    )
  } else {
    content = (
      <div className="block block-empty">
        <div className="container">
          <div className="block-empty__body">
            <div className="block-empty__message">Your shopping cart is empty!</div>
            <div className="block-empty__actions">
              <AppLink href="/" className="btn btn-primary btn-sm">
                Continue
              </AppLink>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <Fragment>
      <Head>
        <title>{`Shopping Cart`}</title>
      </Head>

      <PageHeader header="Shopping Cart" breadcrumb={breadcrumb} />

      {content}
    </Fragment>
  )
}

export default CartPage
