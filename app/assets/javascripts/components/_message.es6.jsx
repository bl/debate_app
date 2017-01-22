class Message extends React.Component {
  render () {
    return (
      <div>
        <div>Body: { this.props.body }</div>
      </div>
    );
  }
}

Message.propTypes = {
  body: React.PropTypes.node,
};
