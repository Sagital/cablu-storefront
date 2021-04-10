// third-party
import classNames from 'classnames'

// application
import AppLink from '../shared/AppLink'
import AsyncAction from '../shared/AsyncAction'
import Cart16Svg from '../../svg/cart-16.svg'
import CurrencyFormat from '../shared/CurrencyFormat'
import url from '../../services/url'
import { IProduct } from '../../interfaces/product'
//import { useCartAddItem } from '../../store/cart/cartHooks';

export interface SuggestionsProps {
  context: 'header' | 'mobile-header' | 'indicator'
  className?: string
  products: IProduct[]
}

function Suggestions(props: SuggestionsProps) {
  const { context, className, products } = props
  const rootClasses = classNames(`suggestions suggestions--location--${context}`, className)
  const cartAddItem = (p: IProduct) => new Promise(res => {})

  const list =
    products &&
    products.map(product => (
      <li key={product.id} className="suggestions__item">
        {product.thumbnail && (
          <div className="suggestions__item-image product-image">
            <div className="product-image__body">
              <img className="product-image__img" src={product.thumbnail.src} alt="" />
            </div>
          </div>
        )}
        <div className="suggestions__item-info">
          <AppLink href={url.product(product)} className="suggestions__item-name">
            {product.name}
          </AppLink>
          <div className="suggestions__item-meta">SKU: 83690/32</div>
        </div>
        <div className="suggestions__item-price">
          <CurrencyFormat value={product.price} />
        </div>
        {context === 'header' && (
          <div className="suggestions__item-actions">
            <AsyncAction
              action={() => cartAddItem(product)}
              render={({ run, loading }) => (
                <button
                  type="button"
                  onClick={run}
                  title="Add to cart"
                  className={classNames('btn btn-primary btn-sm btn-svg-icon', {
                    'btn-loading': loading,
                  })}
                >
                  <Cart16Svg />
                </button>
              )}
            />
          </div>
        )}
      </li>
    ))

  return (
    <div className={rootClasses}>
      <ul className="suggestions__list">{list}</ul>
    </div>
  )
}

export default Suggestions
