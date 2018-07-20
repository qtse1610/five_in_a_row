#include "client.h"

Client::Client(QObject *parent): QTcpSocket(parent)
{
    m_port = 1234;
    m_connected = false;
    //m_socket=new QTcpSocket();

    QObject::connect(this, &Client::readyRead, this, &Client::sockt_recv_data);
    //QObject::connect(m_socket,&QTcpSocket::readyRead,this, &Client::sockt_recv_data);
    QObject::connect(this, &QTcpSocket::disconnected,this, &Client::socket_disconnect);
}

Client::~Client()
{

}


int Client::receive() const
{
    return m_receive;
}

int Client::sender() const
{
    return m_sender;
}

void Client::setSender(const int &sender)
{
    m_sender = sender;
    emit senderChanged();
}

void Client::sockt_recv_data()
{
    QByteArray data_tmp;
    data_tmp = this->readAll();
    if (!data_tmp.isEmpty())
    {
        QString str = QString(data_tmp);
        setReceive(str.toInt());
    }
}

void Client::socket_disconnect()
{
    QMessageBox msgBox;
    msgBox.setText("连接断开！");
    setConnected(false);
    msgBox.resize(40,30);
    msgBox.exec();
}

bool Client::connected() const
{
    return m_connected;
}

void Client::setConnected(bool connected)
{
    m_connected = connected;
    emit connectedChanged();
}


void Client::setReceive(const int &receive)
{
    m_receive = receive;
    emit receiveChanged();
}

void Client::connect()
{
    this->abort();
    this->connectToHost(m_ip, m_port);

    if (!this->waitForConnected(-1))
    {

        QMessageBox msgBox;
        msgBox.setText("连接超时！");
        msgBox.resize(40,30);
        msgBox.exec();
        return;
    }
    setConnected(true);
    auto s = QString("connected");
    this->write(s.toUtf8());
    this->flush();

    QMessageBox msgBox;
    msgBox.setText("连接成功！");
    msgBox.resize(40,30);
    msgBox.exec();
}


void Client::on_pushButton_Send_clicked()
{
    if (m_sender == -1)
        return;
    QString s = QString::number(m_sender, 10);
    if (s.size() == 0) //空消息检测
    {
        QMessageBox msgb;
        msgb.setText("不能发送空消息！");
        msgb.resize(60,40);
        msgb.exec();
        return;
    }

    this->write(s.toUtf8());
    this->flush();
}

QString Client::ip() const
{
    return m_ip;
}

void Client::setIp(const QString &ip)
{
    m_ip = ip;
    emit ipChanged();
}
