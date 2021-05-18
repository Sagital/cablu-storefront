// third-party
import Head from 'next/head'

// application
import AppLink from '../components/shared/AppLink'
import Check100Svg from '../svg/check-100.svg'
import CurrencyFormat from '../components/shared/CurrencyFormat'
import url from '../services/url'

// data stubs
import theme from '../data/theme'
import { useContext } from 'react'
import SessionContext from '../context/SessionContext'

export default function PageOrderSuccess() {
  const getCurrentDate = () => {
    const yourDate = new Date()
    return yourDate.toISOString().split('T')[0]
  }

  const { session } = useContext(SessionContext)

  const order = session.order

  if (!order) {
    return null
  }

  const items = order.cart.items.map((item, itemIndex) => {
    return (
      <tr key={itemIndex}>
        <td className="order-list__column-image">
          <div className="product-image">
            <AppLink href={url.product(item.product)} className="product-image__body">
              <img
                className="product-image__img"
                src={item.product.thumbnail.src}
                alt={item.product.thumbnail.alt}
              />
            </AppLink>
          </div>
        </td>
        <td className="order-list__column-product">
          <AppLink href={url.product(item)}>{item.product.name}</AppLink>
        </td>
        <td className="order-list__column-quantity" data-title="Qty:">
          {item.quantity}
        </td>
        <td className="order-list__column-total">
          <CurrencyFormat value={item.total} />
        </td>
      </tr>
    )
  })

  return (
    <div className="block order-success">
      <Head>
        <title>{`Order Success — ${theme.name}`}</title>
      </Head>

      <div className="container">
        <div className="order-success__body">
          <div className="order-success__header">
            <Check100Svg className="order-success__icon" />
            <h1 className="order-success__title">Thank you</h1>
            <div className="order-success__subtitle">Your order has been received</div>
            <div className="order-success__actions">
              <AppLink href="/" className="btn btn-xs btn-secondary">
                Go To Homepage
              </AppLink>
            </div>
          </div>

          <div className="order-success__meta">
            <ul className="order-success__meta-list">
              <li className="order-success__meta-item">
                <span className="order-success__meta-title">Order number:</span>
                <span className="order-success__meta-value">{`#${atob(order.id)}`}</span>
              </li>
              <li className="order-success__meta-item">
                <span className="order-success__meta-title">Created at:</span>
                <span className="order-success__meta-value">{getCurrentDate()}</span>
              </li>
              <li className="order-success__meta-item">
                <span className="order-success__meta-title">Total:</span>
                <span className="order-success__meta-value">
                  <CurrencyFormat value={order.cart.total} />
                </span>
              </li>
              <li className="order-success__meta-item">
                <span className="order-success__meta-title">Payment method:</span>
                <span className="order-success__meta-value">Ramburs</span>
              </li>
            </ul>
          </div>

          <div className="card">
            <div className="order-list">
              <table>
                <thead className="order-list__header">
                  <tr>
                    <th className="order-list__column-label" colSpan={2}>
                      Product
                    </th>
                    <th className="order-list__column-quantity">Qty</th>
                    <th className="order-list__column-total">Total</th>
                  </tr>
                </thead>
                <tbody className="order-list__products">{items}</tbody>

                <tfoot className="order-list__footer">
                  <tr>
                    <th className="order-list__column-label" colSpan={3}>
                      Total
                    </th>
                    <td className="order-list__column-total">
                      <CurrencyFormat value={order.cart.total} />
                    </td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>

          <div className="row mt-3 no-gutters mx-n2">
            <div className="col-sm-6 col-12 px-2">
              <div className="card address-card">
                <div className="address-card__body">
                  <div className="address-card__badge address-card__badge--muted">
                    Shipping Address
                  </div>
                  <div className="address-card__name">
                    {`${order.shippingAddress.firstName} ${order.shippingAddress.lastName}`}
                  </div>
                  <div className="address-card__row">
                    {order.shippingAddress.streetAddress}
                    <br />
                    {order.shippingAddress.locality}
                    <br />
                    {order.shippingAddress.region}
                  </div>
                  <div className="address-card__row">
                    <div className="address-card__row-title">Phone Number</div>
                    <div className="address-card__row-content">{order.shippingAddress.phone}</div>
                  </div>
                  <div className="address-card__row">
                    <div className="address-card__row-title">Email Address</div>
                    <div className="address-card__row-content">{order.email}</div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-6 col-12 px-2 mt-sm-0 mt-3">
              <div className="card address-card">
                <div className="address-card__body">
                  <div className="address-card__badge address-card__badge--muted">
                    Billing Address
                  </div>
                  <div className="address-card__name">
                    {`${order.billingAddress.firstName} ${order.billingAddress.lastName}`}
                  </div>
                  <div className="address-card__row">
                    {order.billingAddress.streetAddress}
                    <br />
                    {order.billingAddress.locality}
                    <br />
                    {order.billingAddress.region}
                  </div>
                  <div className="address-card__row">
                    <div className="address-card__row-title">Phone Number</div>
                    <div className="address-card__row-content">{order.billingAddress.phone}</div>
                  </div>
                  <div className="address-card__row">
                    <div className="address-card__row-title">Email Address</div>
                    <div className="address-card__row-content">{order.email}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
