interface Props {
  description: string
}

function ProductTabDescription(props: Props) {
  const blocks: Array<{ data: { text: string } }> = JSON.parse(props.description).blocks

  return (
    <>
      {blocks.map((b, i) => (
        <div key={i} className="typography">
          {b.data.text}
        </div>
      ))}
    </>
  )
}

export default ProductTabDescription
