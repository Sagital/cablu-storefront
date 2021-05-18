// react
import { Fragment, memo, useContext } from 'react'

// third-party
import classNames from 'classnames'

// application
import AppLink from './AppLink'
import AsyncAction from './AsyncAction'
import CurrencyFormat from './CurrencyFormat'
import Quickview16Svg from '../../svg/quickview-16.svg'

import { IProduct } from '../../interfaces/product'
import SessionContext from '../../context/SessionContext'

export type ProductCardLayout = 'grid-sm' | 'grid-nl' | 'grid-lg' | 'list' | 'horizontal'

export interface ProductCardProps {
  product: IProduct
  layout?: ProductCardLayout
}

function ProductCard(props: ProductCardProps) {
  const { product, layout } = props
  const containerClasses = classNames('product-card', {
    'product-card--layout--grid product-card--size--sm': layout === 'grid-sm',
    'product-card--layout--grid product-card--size--nl': layout === 'grid-nl',
    'product-card--layout--grid product-card--size--lg': layout === 'grid-lg',
    'product-card--layout--list': layout === 'list',
    'product-card--layout--horizontal': layout === 'horizontal',
  })

  const { session, actions } = useContext(SessionContext)

  const cartAddItem = (product: IProduct) => {
    return actions.addToCart({ product, quantity: 1, id: session.checkout.id })
  }
  const quickviewOpen = (slug: string) => new Promise(() => {})

  let image
  let price
  let features

  if (product.thumbnail) {
    image = (
      <div className="product-card__image product-image">
        <AppLink href={'/p/' + product.id} className="product-image__body">
          <img className="product-image__img" src={product.thumbnail.src} alt="" />
        </AppLink>
      </div>
    )
  }

  price = (
    <div className="product-card__prices">
      <CurrencyFormat value={product.price} />
    </div>
  )

  if (product.attributes && product.attributes.length) {
    features = (
      <ul className="product-card__features-list">
        {product.attributes
          .filter(x => x.featured)
          .map((attribute, index) => (
            <li key={index}>{`${attribute.name}: ${attribute.values
              .map(x => x.name)
              .join(', ')}`}</li>
          ))}
      </ul>
    )
  }

  return (
    <div className={containerClasses}>
      <AsyncAction
        action={() => {
          return quickviewOpen(product.slug)
        }}
        render={({ run, loading }) => (
          <button
            type="button"
            onClick={run}
            className={classNames('product-card__quickview', {
              'product-card__quickview--preload': loading,
            })}
          >
            <Quickview16Svg />
          </button>
        )}
      />

      {image}
      <div className="product-card__info">
        <div className="product-card__name">
          <AppLink href={'/p/' + product.id}>{product.name}</AppLink>
        </div>
        {features}
      </div>
      <div className="product-card__actions">
        <div className="product-card__availability">
          Availability:
          <span className="text-success">In Stock</span>
        </div>
        {price}
        <div className="product-card__buttons">
          {product.quantityAvailable > 0 && (
            <AsyncAction
              action={() => cartAddItem(product)}
              render={({ run, loading }) => (
                <Fragment>
                  <button
                    type="button"
                    onClick={run}
                    className={classNames('btn btn-primary product-card__addtocart', {
                      'btn-loading': loading,
                    })}
                  >
                    Add To Cart
                  </button>
                  <button
                    type="button"
                    onClick={run}
                    className={classNames(
                      'btn btn-secondary product-card__addtocart product-card__addtocart--list',
                      {
                        'btn-loading': loading,
                      }
                    )}
                  >
                    Add To Cart
                  </button>
                </Fragment>
              )}
            />
          )}
        </div>
      </div>
    </div>
  )
}

export default memo(ProductCard)
