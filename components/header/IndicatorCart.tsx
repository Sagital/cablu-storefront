// react
import { Fragment, useContext } from 'react'

// third-party
import classNames from 'classnames'

// application
import AppLink from '../shared/AppLink'
import AsyncAction from '../shared/AsyncAction'
import Cart20Svg from '../../svg/cart-20.svg'
import Cross10Svg from '../../svg/cross-10.svg'
import CurrencyFormat from '../shared/CurrencyFormat'
import Indicator from './Indicator'
import url from '../../services/url'
import { Cart, CartLine } from '../types'
import SessionContext from '../../context/SessionContext'
import { ICheckout } from '../../types'
//import { useCart, useCartRemoveItem } from '../../store/cart/cartHooks';

function IndicatorCart() {
  const { session, actions } = useContext(SessionContext)

  const cartRemoveItem = (checkoutId: string, lineId: string) => {
    return actions.removeCartItem({ id: checkoutId, lineId })
  }
  let dropdown
  let totals

  const items = session.checkout?.cart?.items?.map((item: CartLine) => {
    let image

    if (item.product.thumbnail) {
      image = (
        <div className="product-image dropcart__product-image">
          <AppLink href={url.product(item.product)} className="product-image__body">
            <img className="product-image__img" src={item.product.thumbnail.src} alt="" />
          </AppLink>
        </div>
      )
    }

    const removeButton = (
      <AsyncAction
        action={() => cartRemoveItem(session.checkoutId, item.id)}
        render={({ run, loading }) => {
          const classes = classNames('dropcart__product-remove btn btn-light btn-sm btn-svg-icon', {
            'btn-loading': loading,
          })

          return (
            <button type="button" onClick={run} className={classes}>
              <Cross10Svg />
            </button>
          )
        }}
      />
    )

    return (
      <div key={item.id} className="dropcart__product">
        {image}
        <div className="dropcart__product-info">
          <div className="dropcart__product-name">
            <AppLink href={url.product(item.product)}>{item.product.name}</AppLink>
          </div>
          <div className="dropcart__product-meta">
            <span className="dropcart__product-quantity">{item.quantity}</span>
            {' × '}
            <span className="dropcart__product-price">
              <CurrencyFormat value={item.product.price} />
            </span>
          </div>
        </div>
        {removeButton}
      </div>
    )
  })

  if (session.checkout?.cart?.quantity) {
    dropdown = (
      <div className="dropcart">
        <div className="dropcart__products-list">{items}</div>

        <div className="dropcart__totals">
          <table>
            <tbody>
              {totals}
              <tr>
                <th>Total</th>
                <td>
                  <CurrencyFormat value={session.checkout?.cart.total} />
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div className="dropcart__buttons">
          <AppLink href={url.cart()} className="btn btn-secondary">
            View Cart
          </AppLink>
          <AppLink href={url.checkout()} className="btn btn-primary">
            Checkout
          </AppLink>
        </div>
      </div>
    )
  } else {
    dropdown = (
      <div className="dropcart">
        <div className="dropcart__empty">Your shopping cart is empty!</div>
      </div>
    )
  }

  return (
    <Indicator
      url="/cart"
      dropdown={dropdown}
      value={session.checkout?.cart?.quantity || 0}
      icon={<Cart20Svg />}
    />
  )
}

export default IndicatorCart
