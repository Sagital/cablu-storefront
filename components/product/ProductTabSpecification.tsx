// data stubs
import dataShopProductSpec from '../../data/shopProductSpec'
import { IProductAttribute } from '../../interfaces/product'

interface Props {
  attributes: IProductAttribute[]
}

function ProductTabSpecification(props: Props) {
  const features = props.attributes.map((attribute, index) => (
    <div key={index} className="spec__row">
      <div className="spec__name">{attribute.name}</div>
      <div className="spec__value">{attribute.values?.[0]?.name}</div>
    </div>
  ))

  return (
    <div className="spec">
      <h3 className="spec__header">Specification</h3>
      <div className="spec__section">
        <h4 className="spec__section-title">General</h4>
        {features}
      </div>

      <div className="spec__disclaimer">
        Information on technical characteristics, the delivery set, the country of manufacture and
        the appearance of the goods is for reference only and is based on the latest information
        available at the time of publication.
      </div>
    </div>
  )
}

export default ProductTabSpecification
