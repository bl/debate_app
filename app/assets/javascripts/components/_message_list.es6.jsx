class MessageList extends React.Component {
  render () {
    var messageNodes = this.props.messages.map(function(message) {
      return <Message body={ message.body } key={ message.id } />
    });
    return (
      <div classname="message-list">
        { messageNodes }
      </div>
    );
  }
}

MessageList.propTypes = {
  id: React.PropTypes.number,
  message: React.PropTypes.instanceOf(Message)
};
